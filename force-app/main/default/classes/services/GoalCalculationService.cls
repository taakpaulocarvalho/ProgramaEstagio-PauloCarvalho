public with sharing class GoalCalculationService {
    
    public static Set<String> realizedStatus = new Set<String>{'Integrated'};
    public static Set<String> negotiatedStatus = new Set<String>{'New', 'In Approval', 'Approved'};

    public static String rtPerformance = 'Performance';
    public static String rtPayment = 'Payment_Terms';
    public static String rtProduct = 'Product';
    public static String rtHierarchy = 'Product_Hierarchy';

    public static void calculateGoals(List<Goal__c> scope){

        if (scope == null || scope.isEmpty()) return;

        Set<Id> sellerIds = new Set<Id>();
        Set<Id> goalIds = new Set<Id>();
        Map<Id, Id> sellerByGoal = new Map<Id, Id>();
        
        for (Goal__c goal : scope) {
            
            sellerIds.add(goal.Seller__c);
            goalIds.add(goal.Id);
            sellerByGoal.put(goal.Id, goal.Seller__c);
        }

        List<GoalItem__c> goalItems = getGoalItems(goalIds);

        Integer actualYear = Date.today().year();
        Date yearStart = Date.newInstance(actualYear, 1, 1);
        Date yearEnd = Date.newInstance(actualYear, 12, 31);

        Set<String> validStatus = new Set<String>();
        validStatus.addAll(realizedStatus);
        validStatus.addAll(negotiatedStatus);


        //INICIALIZAÇÃO DOS MAPAS
        Map<Id, Decimal> sumPerfomanceRealized = new Map<Id, Decimal>();
        Map<Id, Decimal> sumPerfomanceNegotiated = new Map<Id, Decimal>();

        Map<Id, Map<String, Decimal>> sumPaymentRealized = new Map<Id, Map<String, Decimal>>();
        Map<Id, Map<String, Decimal>> sumPaymentNegotiated = new Map<Id, Map<String, Decimal>>();

        Map<Id, Map<Id, Decimal>> sumProductRealized = new Map<Id, Map<Id, Decimal>>();
        Map<Id, Map<Id, Decimal>> sumProductNegotiated = new Map<Id, Map<Id, Decimal>>();
        
        Map<Id, Map<String, Decimal>> sumHierarchyRealized = new Map<Id, Map<String, Decimal>>();
        Map<Id, Map<String, Decimal>> sumHierarchyNegotiated = new Map<Id, Map<String, Decimal>>();

        for (Id sellerId : sellerIds) {

            sumPerfomanceRealized.put(sellerId, 0);
            sumPerfomanceNegotiated.put(sellerId, 0);

            sumPaymentRealized.put(sellerId, new Map<String, Decimal>());
            sumPaymentNegotiated.put(sellerId, new Map<String, Decimal>());

            sumProductRealized.put(sellerId, new Map<Id, Decimal>());
            sumProductNegotiated.put(sellerId, new Map<Id, Decimal>());

            sumHierarchyRealized.put(sellerId, new Map<String, Decimal>());
            sumHierarchyNegotiated.put(sellerId, new Map<String, Decimal>());
        }


        //TRAZ VALORES PROCESSADOS DO BANCO ATRAVES DO AGGREGATE RESULT
        AggregateResult[] orderAggregate = [
            SELECT OwnerId, Status, Payment_Terms__C, SUM(TotalAmount) totalSold
            FROM Order
            WHERE OwnerId IN :sellerIds AND Status IN :validStatus 
             AND EffectiveDate >= :yearStart AND EffectiveDate <= :yearEnd
            GROUP BY OwnerID, Status, Payment_Terms__c
        ];

        for (AggregateResult agResult : orderAggregate) {

            Id ownerId = (Id) agResult.get('OwnerId');
            String status = (String) agResult.get('Status');
            String paymentTerm = (String) agResult.get('Payment_Terms__c');
            Decimal total = (Decimal) agResult.get('totalSold');

            if (total == null) total = 0;

            if (realizedStatus.contains(status)){
                sumPerfomanceRealized.put(ownerId, sumPerfomanceRealized.get(ownerId) + total);

                if (paymentTerm != null){

                    Decimal value = sumPaymentRealized.get(ownerId).containsKey(paymentTerm) ? sumPaymentRealized.get(ownerId).get(paymentTerm) : 0;
                    sumPaymentRealized.get(ownerId).put(paymentTerm, value + total);
                }
            } else if (negotiatedStatus.contains(status)){

                sumPerfomanceNegotiated.put(ownerId, sumPerfomanceNegotiated.get(ownerId) + total);
                if (paymentTerm != null){
                    Decimal value = sumPaymentNegotiated.get(ownerId).containsKey(paymentTerm) ? sumPaymentNegotiated.get(ownerId).get(paymentTerm) : 0;
                    sumPaymentNegotiated.get(ownerId).put(paymentTerm, value + total);
                }
            }
        }

        //PROCESSA ITENS DO PEDIDO
        AggregateResult[] itemsAggregated = [
            SELECT Order.OwnerId seller, Order.Status status, Product2Id, Product2.Product_Hierarchy__c hierarchy, SUM(TotalPrice) totalSold
            FROM OrderItem WHERE Order.OwnerId IN :sellerIds AND Order.Status IN :validStatus
            AND Order.EffectiveDate >= :yearStart AND Order.EffectiveDate <= :yearEnd
            GROUP BY Order.OwnerId, Order.Status, Product2Id, Product2.Product_Hierarchy__c
        ];

        for (AggregateResult arResult : itemsAggregated) {
            Id ownerId = (Id) arResult.get('seller');
            String status = (String) arResult.get('status');
            Id productId = (Id) arResult.get('Product2Id');
            String hierarchy = (String) arResult.get('hierarchy');
            Decimal total = (Decimal) arResult.get('totalSold');
            if (total == null) total = 0;

            if (realizedStatus.contains(status)) {
                if (productId != null) {
                    Decimal value = sumProductRealized.get(ownerId).containsKey(productId) ? sumProductRealized.get(ownerId).get(productId) : 0;
                    sumProductRealized.get(ownerId).put(productId, value + total);
                }
                if (hierarchy != null) {
                    Decimal value = sumHierarchyRealized.get(ownerId).containsKey(hierarchy) ? sumHierarchyRealized.get(ownerId).get(hierarchy) : 0;
                    sumHierarchyRealized.get(ownerId).put(hierarchy, value + total);
                }
            } else if (negotiatedStatus.contains(status)) {
                if (productId != null) {
                    Decimal value = sumProductNegotiated.get(ownerId).containsKey(productId) ? sumProductNegotiated.get(ownerId).get(productId) : 0;
                    sumProductNegotiated.get(ownerId).put(productId, value + total);
                }
                if (hierarchy != null) {
                    Decimal value = sumHierarchyNegotiated.get(ownerId).containsKey(hierarchy) ? sumHierarchyNegotiated.get(ownerId).get(hierarchy) : 0;
                    sumHierarchyNegotiated.get(ownerId).put(hierarchy, value + total);
                }
            }
        }


        //ATRIBUINDO VALORES
        List<Goal__c> goalsToUpdate = new List<Goal__c>();
        List<GoalItem__c> goalItemsToUpdate = new List<GoalItem__c>();

        for (Goal__c goal : scope) {
            
            Decimal totalSold = sumPerfomanceRealized.get(goal.Seller__c);
            if (totalSold == null) totalSold = 0;

            if (goal.Sales_Value__c != totalSold) {
                goal.Sales_Value__c = totalSold;
                goalsToUpdate.add(goal);
            }
        }

        for (GoalItem__c item : goalItems) {

            Id sellerId = sellerByGoal.get(item.Goal__c);
            Decimal realizedValue = 0;
            Decimal negotiatedValue = 0;

            System.debug('=== ITEM DA META ===');
            System.debug('1. Record Type da Meta: ' + item.RecordType.DeveloperName);
            System.debug('2. ID do Vendedor: ' + sellerId);
            System.debug('3. Produto da Meta: ' + item.Product__c);
            System.debug('4. Pagamento da Meta: ' + item.Payment_Terms__c);
            System.debug('5. Valor de Performance Realized: ' + sumPerfomanceRealized);
            System.debug('5. Valor de Performance Negotiated: ' + sumPerfomanceNegotiated);
            System.debug('6. Mapa de Produtos: ' + sumProductNegotiated);
            System.debug('=================================');

            if (item.RecordType.DeveloperName == rtPerformance){

                realizedValue = sumPerfomanceRealized.get(sellerId) != null ? sumPerfomanceRealized.get(sellerId) : 0;
                negotiatedValue = sumPerfomanceNegotiated.get(sellerId) != null ? sumPerfomanceNegotiated.get(sellerId) : 0;
            }
            else if (item.RecordType.DeveloperName == rtPayment){

                if (item.Payment_Terms__c != null){

                    String paymentKey = String.valueOf(item.Payment_Terms__c);
                    
                    Map<String, Decimal> mapRealized = sumPaymentRealized.get(sellerId);
                    Map<String, Decimal> mapNegotiated = sumPaymentNegotiated.get(sellerId);

                    realizedValue = (mapRealized != null && mapRealized.containsKey(paymentKey) ? mapRealized.get(paymentKey) : 0);     
                    negotiatedValue = (mapNegotiated != null && mapNegotiated.containsKey(paymentKey) ? mapNegotiated.get(paymentKey) : 0);
                } 
            }
            else if (item.RecordType.DeveloperName == rtProduct){
                if (item.Product__c != null){
                    
                    Map<Id, Decimal> mapRealized = sumProductRealized.get(sellerId);
                    Map<Id, Decimal> mapNegotiated = sumProductNegotiated.get(sellerId);

                    realizedValue = (mapRealized != null && mapRealized.containsKey(item.Product__c) ? mapRealized.get(item.Product__c) : 0);
                    negotiatedValue = (mapNegotiated != null && mapNegotiated.containsKey(item.Product__c) ? mapNegotiated.get(item.Product__c) : 0);
                }
            }
            else if (item.RecordType.DeveloperName == rtHierarchy){
                if (item.Product_Hierarchy__c != null){
                                        
                    Map<String, Decimal> mapRealized = sumHierarchyRealized.get(sellerId);
                    Map<String, Decimal> mapNegotiated = sumHierarchyNegotiated.get(sellerId);

                    realizedValue = (mapRealized != null && mapRealized.containsKey(item.Product_Hierarchy__c) ? mapRealized.get(item.Product_Hierarchy__c) : 0);
                    negotiatedValue = (mapNegotiated != null && mapNegotiated.containsKey(item.Product_Hierarchy__c) ? mapNegotiated.get(item.Product_Hierarchy__c) : 0);
                }
            }
            
            //ATUALIZA OS CAMPOS DO ITEM
            item.Realized_Value__c = realizedValue;
            System.debug('Realized value: ' + realizedValue);
            item.Negotiated_Value__c = negotiatedValue;
            System.debug('Negotiated value: ' + negotiatedValue);
            
            item.Projected_Value__c = realizedValue + negotiatedValue;

            if (item.Projected_Value__c >= item.Goal_Value__c){
                item.Percentage_Achieved__c = item.Commission_Percentage_Based_on_Goal__c;
            }
            else{
                item.Percentage_Achieved__c = 0;
            }

            goalItemsToUpdate.add(item);
        }

        if (!goalsToUpdate.isEmpty()) Database.update(goalsToUpdate, false);
        if (!goalItemsToUpdate.isEmpty()) Database.update(goalItemsToUpdate, false);        

    }

    //FAZ A QUERY BUSCANDO OS ITENS DE META
    private static List<GoalItem__c> getGoalItems(Set<Id> goalIds) {

        return [SELECT Id, Goal__c, Goal_Value__c, Negotiated_Value__c, Projected_Value__c,
                        Percentage_Achieved__c, Realized_Value__c, Commission_Percentage_Based_on_Goal__c, Product_Hierarchy__c, 
                        Payment_Terms__c, RecordType.DeveloperName, Product__c FROM GoalItem__c WHERE Goal__c IN :goalIds
        ];
    }
}