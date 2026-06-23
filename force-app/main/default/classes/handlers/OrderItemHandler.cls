public with sharing class OrderItemHandler extends TriggerHandler{

    public override void beforeInsert(){
        collectOrdersAndProducts((List<OrderItem>) Trigger.new);
    }

    public override void beforeUpdate(){
        collectOrdersAndProducts((List<OrderItem>) Trigger.new);
    }

    //=============================================== PROCESSADOR DE PEDIDOS E PRODUTOS ===========================================================
    private void collectOrdersAndProducts(List<OrderItem> newItems){

        Set<Id> orderIds = new Set<Id>();
        Set<Id> productIds = new Set<Id>();

        //COLETAR IDS DOS PEDIDOS E PRODUTOS
        for (OrderItem item : newItems){
            if (item.OrderId != null) orderIds.add(item.OrderId);
            if (item.Product2Id != null) productIds.add(item.Product2Id);
        }

        //CONSULTA UNICA PARA PEDIDOS
        Map<Id, Order> orderMap = new Map<Id, Order>([
            SELECT Id, AccountId, Account.Customer_Group__c, Distribution_Center__c,
                   Address__r.City__c, Address__r.City__r.State__c, Address__r.City__r.State__r.Country__c
            FROM Order
            WHERE Id IN :orderIds
        ]);

        //CONSULTA UNICA PARA PRODUTOS
        Map<Id, Product2> productMap = new Map<Id, Product2>([
            SELECT Id, Product_Hierarchy__c, Production_Cost__c
            FROM Product2
            WHERE Id IN :productIds
        ]);

        //CHAMA OS METODOS PASSANDO OS MAPAS DE PEDIDO E PRODUTOS PRONTOS
        applyTax(newItems, orderMap);
        applyFreight(newItems, orderMap, productMap);
        applyMargin(newItems, orderMap, productMap);
        validateRequiredParameters(newItems, productMap);
        calculatePrice(newItems, productMap);
    }

    //=============================================== Tax ===========================================================
    private void applyTax(List<OrderItem>  newItems, Map<Id, Order> orderMap){

        System.debug('==============================================================================================================');
        System.debug('IMPOSTO');

        Set<Id> productIds = new Set<Id>();

        //COLETAR IDS DOS PEDIDOS E PRODUTOS
        for(OrderItem item : newItems){

            if (item.Product2Id != null) productIds.add(item.Product2Id);
        }

        Set<Id> stateIds = new Set<Id>();
        Set<Id> CDIds = new Set<Id>();
        for (Order order : orderMap.values()){
            if (order.Address__r != null && order.Address__r.City__r != null) stateIds.add(order.Address__r.City__r.State__c);
            if (order.Distribution_Center__c != null) CDIds.add(order.Distribution_Center__c);
        }

        //BUSCA DE TaxS APROVADOS PRESENTES NO BANCO
        List<Tax__c> taxFound = [SELECT Id, Product__c,State__c, Tax_On_Cost__c, Distribution_Center__c
                                            FROM Tax__c
                                            WHERE Status__c = 'Aprovado'
                                            AND Product__c IN :productIds
                                            AND State__c IN :stateIds
                                            AND Distribution_Center__c IN :CDIds
                                            ORDER BY CreatedDate DESC
        ]; 

       //MAPEIA IMPOSTOS ENCONTRADOS 
        Map<String, Decimal> taxOnCostMap = new Map<String, Decimal>();
        for (Tax__c tax : taxFound){

            String key = String.valueOf(Tax.Product__c) + String.valueof(Tax.Distribution_Center__c) + String.valueOf(Tax.State__c);
            System.debug('Chave de Impostos no banco que batem com os parametros do pedido: ' + key);
            taxOnCostMap.put(key, Tax.Tax_On_Cost__c);
        }

        //APLICA IMPOSTO SOBRE PRODUTO DO PEDIDO
        for (OrderItem item : newItems){
            Order order = orderMap.get(item.OrderId);

            //PEGA O ESTADO NAVEGANDO PELO RELACIONAMENTO DO PEDIDO
            Id stateId = (order != null && order.Address__r != null && order.Address__r.City__r != null) ? order.Address__r.City__r.State__c : null;

            //CHAVE PARA O ITEM ATUAL
            String keyToSearch = String.valueOf(item.Product2Id) + String.valueOf(order.Distribution_Center__c) + String.valueOf(stateId);

            //VERIFICA SE EXISTE IMPOSTO PARA O ITEM ATUAL
            if (taxOnCostMap.containsKey(keyToSearch)){
                item.Tax_Percentage__c = taxOnCostMap.get(keyToSearch);
                System.debug('Tax: Tax aplicado de ' + item.Tax_Percentage__c + '% para o produto ' + item.Product2Id);
            }
            else{
                System.debug('Sem Tax cadastrado para este produto que bata com os parametros do pedido');
                item.addError('Sem Tax cadastrada para este pedido');
            }

            System.debug('======================================================');
        }
    }

    //=============================================== Freight ===========================================================
    private void applyFreight(List<OrderItem>  newItems, Map<Id, Order> orderMap, Map<Id, Product2> productMap){

        System.debug(' ');
        System.debug('=============================================================================================================='); 
        System.debug('FRETE');

        Set<Id> productIds = new Set<Id>();

        for (OrderItem item : newItems){
            if (item.Product2Id != null) productIds.add(item.Product2Id);
        }

        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();
        Set<Id> hierarchyIds = new Set<Id>();
        Set<Id> distributionCenterds = new Set<Id>();

        //ATRIBUI OS IDS DOS PARAMETROS PARA BUSCAR OS FRETES NO BANCO
        for (Product2 product : productMap.values()){
            if (product.Product_Hierarchy__c != null) hierarchyIds.add(product.Product_Hierarchy__c);
        }

        //ATRIBUI OS IDS DOS PARAMETROS PARA BUSCAR OS FRETES NO BANCO
        for (Order order : orderMap.values()){
            if (order.Address__r != null && order.Address__r.City__c != null){
                cityIds.add(order.Address__r.City__c);
                
                if (order.Address__r.City__r != null){
                    stateIds.add(order.Address__r.City__r.State__c);
                }

                if (order.Address__r.City__r.State__c != null){
                    countryIds.add(order.Address__r.City__r.State__r.Country__c);
                }
            }    
            if (order.Distribution_Center__c != null) distributionCenterds.add(order.Distribution_Center__c);
        }


        //BUSCAR FreightS PRESENTES NO BANCO
        List<Freight__c> freightsFound = [SELECT Id, Product__c, Product_Hierarchy__c, Distribution_Center__c, City__c, State__c, Country__c, Value__c 
                                            FROM Freight__c
                                            WHERE Status__c = 'Aprovado'
                                            AND (Distribution_Center__c IN :distributionCenterds)
                                            AND (Product__c IN :productIds OR Product_Hierarchy__c IN :hierarchyIds)   
                                            AND (City__c IN :cityIds OR State__c IN :stateIds OR Country__c IN :countryIds)
                                            ORDER BY CreatedDate DESC];


        //LOGICA DE ESPECIFIDADE
        for (OrderItem item : newItems){

            Decimal selectedShippingCost = null;
            Integer bestScore = -1;

            if (item.OrderId != null && item.Product2Id != null){
                Order order = orderMap.get(item.OrderId);
                Product2 product = productMap.get(item.Product2Id);

                //LOOP PARA PERCORRER TODOS OS FREIGHTS NO BANCO E SELECIONAR O MAIS ESPECIFICO
                for (Freight__c freight : freightsFound){

                    //VERIFICA SE O Freight ATENDE AO PEDIDO
                    Boolean servesCD = (freight.Distribution_Center__c != null && freight.Distribution_Center__c == order.Distribution_Center__c);
                    Boolean servesProduct = (freight.Product__c != null && freight.Product__c == product.Id);                
                    Boolean servesHierarchy = (freight.Product_Hierarchy__c != null && freight.Product_Hierarchy__c == product.Product_Hierarchy__c);                    
                    Boolean servesCity = (freight.City__c != null && freight.City__c == order.Address__r.City__c);
                    Boolean servesState = (freight.State__c != null && freight.State__c == order.Address__r.City__r.State__c);
                    Boolean servesCountry = (freight.Country__c != null && freight.Country__c == order.Address__r.City__r.State__r.Country__c);

                    //SE ATENDE OS PARAMETROS ESPECIFICOS DO PEDIDO APLICA A LOGICA DE ESPECIFIDADE
                    if (servesCD && (servesProduct || servesHierarchy) && (servesCity || servesState || servesCountry)){
                        
                        //TESTAR SE FICA MELHOR DESCENTRALIZANDO O CALCULO DE ESPECIFIDADE
                        Integer score = CalculateScoreService.calculateScore(servesProduct, servesHierarchy, servesCity, servesState, servesCountry, false, false);
                        
                        System.debug('FRETE: Id do Frete: ' + freight.Id + ' Valor: ' + freight.Value__c  +' Especifidade: ' + score);

                        if (score > bestScore){
                            bestScore = score;
                            selectedShippingCost = freight.Value__c;
                            System.debug('FRETE: Frete vencendo com valor ' + selectedShippingCost + ' e especificidade ' + bestScore);
                        }
                    }
                }
            }

            //ATRIBUI O FRETE SELECIONADO AO CAMPO VALOR DE FRETE EM PRODUTO DO PEDIDO
            if (selectedShippingCost != null){
                System.debug('Valor de Especifidade de Frete selecionada: ' + selectedShippingCost + ' para o produto ' + item.Product2Id + ' com especifidade ' + bestScore);
                item.Shipping_Cost__c = selectedShippingCost;
            }
            else{
                System.debug('FRETE: Nenhum Frete bateu com os parametros do pedido');
                item.addError('Sem Freight cadastrada para este pedido');
            }

            System.debug('======================================================');
        }
    }

    //=============================================== Margin ===========================================================
    private void applyMargin(List<OrderItem> newItems, Map<Id, Order> orderMap, Map<Id, Product2> productMap){

        System.debug(' ');
        System.debug('==============================================================================================================');
        System.debug('MARGIN');
        
        Set<Id> productIds = new Set<Id>();

        for (OrderItem item : newItems){
            if (item.Product2Id != null) productIds.add(item.Product2Id);
        }

        Set<Id> hierarchyIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> accountGroupIds = new Set<Id>();
        Set<Id> distributionCenterIds = new Set<Id>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();

        //ATRIBUI OS IDS DOS PARAMETROS DO PRODUTO PARA BUSCAR AS MARGENS NO BANCO
        for (Product2 product : productMap.values()){
            
            if (product.Product_Hierarchy__c != null) hierarchyIds.add(product.Product_Hierarchy__c);   
        }

        //ATRIBUI OS IDS DOS PARAMETROS DO PEDIDO PARA BUSCAR AS MARGENS NO BANCO
        for (Order order : orderMap.values()){
            
            if (order.AccountId != null) accountIds.add(order.AccountId);
            if (order.Account.Customer_Group__c != null) accountGroupIds.add(order.Account.Customer_Group__c);
            if (order.Distribution_Center__c != null) distributionCenterIds.add(order.Distribution_Center__c);

            if (order.Address__r != null){
                if (order.Address__r.City__c != null) cityIds.add(order.Address__r.City__c);
                if (order.Address__r.City__r.State__c != null) stateIds.add(order.Address__r.City__r.State__c);
                if (order.Address__r.City__r.State__r.Country__c != null) countryIds.add(order.Address__r.City__c);
            }
        }

        //BUSCAR MARGENS PRESENTES NO BANCO
        List<Margin__c> marginsFound = [SELECT Id, Product__c, Product_Hierarchy__c, Distribution_Center__c, Account__c, Account_Group__c, City__c, State__c, Country__c, Value__c
                                                 FROM Margin__c
                                                 WHERE Status__c = 'Aprovado'
                                                 AND (Distribution_Center__c IN :distributionCenterIds)
                                                 AND (Product__c IN :productIds OR Product_Hierarchy__c IN :hierarchyIds)
                                                 AND (Account__c IN :accountIds OR Account_Group__c IN :accountGroupIds)
                                                 AND (City__c IN :cityIds OR State__c IN :stateIds OR Country__c IN :countryIds)
                                                 ORDER BY CreatedDate DESC];


        //LOGICA DE ESPECIFIDADE
        for (OrderItem item : newItems){
            Order order = orderMap.get(item.OrderId);
            Product2 product = productMap.get(item.Product2Id);
            
            Decimal selectedMarginValue = null;
            Integer bestScore = -1;

            for (Margin__c margin : marginsFound){

                //VERIFICA SE A MARGEM ATENDE AO PEDIDO
                Boolean servesCD = (margin.Distribution_Center__c == order.Distribution_Center__c);
                Boolean servesProduct = (margin.Product__c != null && margin.Product__c == item.Product2Id);
                Boolean servesHierarchy = (margin.Product_Hierarchy__c != null && margin.Product_Hierarchy__c == product.Product_Hierarchy__c);
                Boolean servesCity = (margin.City__c != null && margin.City__c == order.Address__r.City__c);
                Boolean servesState = (margin.State__c != null && margin.State__c == order.Address__r.City__r.State__c);
                Boolean servesCountry = (margin.Country__c != null && margin.Country__c == order.Address__r.City__r.State__r.Country__c);
                Boolean servesAccount = (margin.Account__c != null && margin.Account__c == order.AccountId);
                Boolean servesAccountGroup = (margin.Account_Group__c != null && margin.Account_Group__c == order.Account.Customer_Group__c);

                //SE ATENDE OS PARAMETROS ESPECIFICOS DO PEDIDO APLICA A LOGICA DE ESPECIFIDADE
                if (servesCD && (servesProduct || servesHierarchy) && (servesAccount || servesAccountGroup) && (servesCity || servesState || servesCountry )){
                    
                    Integer score = CalculateScoreService.calculateScore(servesProduct, servesHierarchy, servesCity, servesState, servesCountry, servesAccount, servesAccountGroup);

                    System.debug('MARGEM: Id da Margem: ' + margin.Id + ' Valor: ' + margin.Value__c  +'% Especifidade: ' + score);

                    if (score > bestScore){
                        bestScore = score;
                        selectedMarginValue = margin.Value__c;
                        System.debug('MARGIN: Margem vencendo com valor ' + selectedMarginValue + ' e especificidade ' + bestScore);
                    }
                }
            }

            //ATRIBUI A MARGEM SELECIONADA AO CAMPO PORCENTAGEM DE MARGEM EM PRODUTO DO PEDIDO
            if (selectedMarginValue != null){
                System.debug('Valor de Especifidade de Margem selecionada: ' + selectedMarginValue + '  para o produto ' + item.Product2Id + ' com especifidade ' + bestScore);
                item.Margin_Percentage__c = selectedMarginValue;
            }
            else{
                System.debug('MARGEM: Nenhuma Margem bateu com os parametros do pedido');
                item.addError('Sem Margin cadastrada para este pedido');
            }

            System.debug('======================================================');
        }
    }

    //=============================================== VALIDACAO DE PARAMETROS ===========================================================
    private void validateRequiredParameters(List<OrderItem> newItems, Map<Id, Product2> productMap){

        System.debug(' ');
        System.debug('==============================================================================================================');
        System.debug('VALIDAÇÃO DE PARÂMETROS OBRIGATÓRIOS');

        for (OrderItem item : newItems){

            Product2 product = productMap.get(item.Product2Id);

            //VERIFICA SE EXISTE CUSTO DE PRODUCAO NO CADASTRO DO PRODUTO
            Boolean hasProductionCost = (product != null && product.Production_Cost__c != null);

            //VERIFICA SE O PRODUTO TEM TODOS OS PARAMETROS OBRIGATORIOS
            Boolean hasTax = (item.Tax_Percentage__c != null);
            Boolean hasFreight = (item.Shipping_Cost__c != null);
            Boolean hasMargin = (item.Margin_Percentage__c != null);

            System.debug('temCusto: ' + hasProductionCost);
            System.debug('temImposto: ' + hasTax);
            System.debug('temFrete: ' + hasFreight);
            System.debug('temMargem: ' + hasMargin);

            //SE EXISTE ALGUM PARAMETRO FALTANDO, ADICIONA ERRO AO PRODUTO DO PEDIDO
            if (!hasProductionCost || !hasTax || !hasFreight || !hasMargin){
                System.debug('Falta de parametros para o produto ' + item.Product2Id + ': Custo: ' + hasProductionCost + ' Tax: ' + hasTax + ' Freight: ' + hasFreight + ' Margin: ' + hasMargin);
                //item.addError('Não está autorizada a venda deste produto devido a falta de parâmetros, entre em contato com o time de pricing.');
            }
            else{
                item.Production_Cost__c = product.Production_Cost__c;
            }

            System.debug('======================================================');
        }
    }

    //=============================================== CALCULO DE PRECO ===========================================================
    private void calculatePrice(List<OrderItem> newItems, Map<Id, Product2> productMap){

        System.debug(' ');
        System.debug('==============================================================================================================');
        System.debug('CÁLCULO DE PREÇO');

        //FAZ O CALCULO PARA CADA PRODUTO NO PEDIDO
        for (OrderItem item : newItems){
            
            Product2 product = productMap.get(item.Product2Id);

            //VERIFICANDO SE CUSTO DE PRODUCAO EXISTE PARA GARINTIR QUE O CALCULO SEJA REALIZADO
            if (product != null && product.Production_Cost__c != null){
                item.Production_Cost__c = product.Production_Cost__c;
            }

            //CALCULO SO E FEITO SE TODOS OS PARAMETROS FOREM PASSADOS
            if (item.Production_Cost__c != null && item.Tax_Percentage__c != null && item.Margin_Percentage__C != null && item.Tax_Percentage__c != null && item.Shipping_Cost__c != null){

                Decimal productionCost = item.Production_Cost__c;
                Decimal freight = item.Shipping_Cost__c;
                Decimal tax = item.Tax_Percentage__c / 100;
                Decimal margin = item.Margin_Percentage__c  / 100;

                System.debug('Calculando preço para o item ' + item.Product2Id + ' com: \nCusto de produção: ' + productionCost + ' \nFrete: ' + freight + ' \nImposto: ' + (tax*100) + '% \nMargem: ' + (margin*100) + '%');

                //PRECO SEM MARGEM
                Decimal priceWithoutMargin = (productionCost + freight) * (1 + tax);
                item.Price_Without_Margin__c = priceWithoutMargin;

                //PRECO FINAL
                Decimal finalPrice = (productionCost + freight) * (1 + tax) * (1 + margin);
                item.Final_Price__c = finalPrice;

                //SE O PRECO FINAL FOR VALIDO, CALCULA O Discount
                if (finalPrice > 0 && item.UnitPrice != null){

                    Decimal discount = (finalPrice - item.UnitPrice) / finalPrice;

                    if (discount <= 0){
                        item.Discount__c = 0.0;
                        item.Increase__c = discount * -100;
                    }
                    else{
                        item.Discount__c = discount * 100;
                        item.Increase__c = 0.0;
                    }
                    
                    System.debug('Preço final ideal calculado: ' + finalPrice + ' Preço de venda: ' + item.UnitPrice + ' Desconto aplicado: ' + (discount*100) + '%');
                }
                else{
                    item.Discount__c = 0.0;
                }

                System.debug('======================================================');
            } 
        }
    }
}