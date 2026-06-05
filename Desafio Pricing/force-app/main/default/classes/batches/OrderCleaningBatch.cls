public class OrderCleaningBatch implements Database.Batchable<sObject>, Schedulable {


    public Database.QueryLocator start (Database.BatchableContext bc){

        Integer numberOfMonths = 6;

        List<DevParameters__mdt> devParameters = [SELECT Value__c
                                                FROM DevParameters__mdt
                                                WHERE DeveloperName = 'MaxNumberMonthsOrder'
                                                LIMIT 1];

        if (!devParameters.isEmpty() && devParameters[0].Value__c != null){

            try{
                numberOfMonths = Integer.valueOf(devParameters[0].Value__c);
            } catch (Exception e){
                System.debug('Erro ao converter o valor do metadado para Integer. Erro: ' + e.getMessage());
            }  
        }

        Date targetDate = Date.today().addMonths(-numberOfMonths);

        return Database.getQueryLocator(
            [SELECT Id FROM Order WHERE EffectiveDate < :targetDate]
        );
    }
    
    public void execute(Database.BatchableContext bc, List<Order> scope){

        if (scope == null || scope.isEmpty()) return;

        Set<Id> orderIds = new Set<Id>();
        for (Order order : scope){
            orderIds.add(order.Id);
        }

        List<SObject> recordsToDelete = new List<SObject>();

        List<OrderItem> itemsToDelete = [SELECT Id FROM OrderItem WHERE OrderId IN :orderIds];
        
        for (OrderItem item : itemsToDelete){
            recordsToDelete.add(item);
        }

        List<IntegrationLog__c> logsToDelete = [SELECT Id FROM IntegrationLog__c WHERE Order__c IN :orderIds];

        for (IntegrationLog__c log : logsToDelete){
            recordsToDelete.add(log);
        }

        if (!recordsToDelete.isEmpty()){
            delete recordsToDelete;
        }

        delete scope;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Limpeza de pedidos antigos finalizado via Batch');
    }

    public void execute(SchedulableContext sc){

        OrderCleaning ordClean = new OrderCleaning();
        Database.executeBatch(ordClean, 10);
    }
}