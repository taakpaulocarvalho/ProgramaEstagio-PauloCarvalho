@isTest
public class OrderCleaningTest {
    
    @testSetup
    static void makeData(){

        TestFactorySObject factory = TestFactorySObject.getInstance();
    
        Account_Group__c accountGroup = (Account_Group__c) factory.createSObject(new Account_Group__c());
        insert accountGroup;
    
        Account account = (Account) factory.createSObject(new Account(Customer_Group__c = accountGroup.Id));
        insert account;
    
        Country__c Country = (Country__c) factory.createSObject(new Country__c());
        insert Country;
    
        State__c state = (State__c) factory.createSObject(new State__c(Country__c = Country.Id));
        insert state;
    
        City__c city = (City__c) factory.createSObject(new City__c(State__c = state.Id));
        insert city;
    
        Account_Address__c accountAddress = (Account_Address__c) factory.createSObject(new Account_Address__c(Account__c = account.Id, City__c = city.Id));
        insert accountAddress;
    
        Distribution_Center__c DC = (Distribution_Center__c) factory.createSObject(new Distribution_Center__c());
        insert DC;
    
        Payment_Terms__c paymentTerms = (Payment_Terms__c) factory.createSObject(new Payment_Terms__c());
        insert paymentTerms;
    
        Product_Hierarchy__c productHierarchy = (Product_Hierarchy__c) factory.createSObject(new Product_Hierarchy__c());
        insert productHierarchy;
    
        Product2 product = (Product2) factory.createSObject(new Product2(Product_Hierarchy__c = productHierarchy.Id, Production_Cost__c = 100));
        insert product;
    
        PricebookEntry pbe = [SELECT Pricebook2Id FROM PricebookEntry WHERE Product2Id = :product.Id LIMIT 1];
        
        //CRIANDO DADOS PARA IMPOSTO
        Tax__c tax = (Tax__c) factory.createSObject(new Tax__c(Distribution_Center__c = DC.Id, State__c = state.Id, Product__c = product.Id, Tax_On_Cost__c = 10));
        insert tax;

        //CRIANDO DADOS PARA MARGEM
        Margin__c margin = (Margin__c) factory.createSObject(new Margin__c(Distribution_Center__c = DC.Id, Account__c = account.Id, Product__c = product.Id, City__c = city.Id, Value__c = 20));
        insert margin;

        //CRIANDO DADOS PARA FRETE
        Freight__c freight = (Freight__c) factory.createSObject(new Freight__c(Distribution_Center__c = DC.Id, City__c = city.Id, Product__c = product.Id, Value__c = 100, Status__c = 'Aprovado'));
        insert freight;
        
        List<Order> ordersToInsert = new List<Order>();
        List<OrderItem> itemsToInsert = new List<OrderItem>();
        List<IntegrationLog__c> logsToInsert = new List<IntegrationLog__c>();
        for (Integer i = 0; i < 10; i++){
            
            Order orderTest = (Order)factory.createSObject(new Order(
                AccountId = account.Id, Distribution_Center__c = DC.Id, Payment_Terms__c = paymentTerms.Id, 
                Address__c = accountAddress.Id, Pricebook2Id = pbe.pricebook2Id, EffectiveDate = Date.today().addMonths(-7)
            ));
            ordersToInsert.add(orderTest);
        }
        insert ordersToInsert;

        for (Order order : ordersToInsert){

            for (Integer i = 0; i < 2; i++){

                OrderItem item = new OrderItem(OrderId = order.Id, Product2Id = product.Id, Quantity = 10, UnitPrice = 1000000, PricebookEntryId = pbe.Id);
                item = (OrderItem) factory.createSObject(item);
                itemsToInsert.add(item);
    
                IntegrationLog__c log = new IntegrationLog__c(Order__c = order.Id);
                log = (IntegrationLog__c) factory.createSObject(log);
                logsToInsert.add(log);
            }
        }
        insert itemsToInsert;
        insert logsToInsert;
    }

    @isTest
    static void testBatchExecution(){

        Test.startTest();
        Database.executeBatch(new OrderCleaning(), 10);
        Test.stopTest();

        List<Order> remainingOrders = [SELECT Id FROM Order WHERE EffectiveDate < :Date.today().addMonths(-6)];
        System.assert(remainingOrders.isEmpty(), 'Todos os pedidos antigos deveriam ter sido deletados');
    }

    @isTest
    static void testScheduledOrderCleaning(){

        String cronExp = '0 0 0 * * ?';

        Test.startTest();

        String jobId = System.schedule('Teste de Agendamento', cronExp, new OrderCleaning());

        Test.stopTest();

        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger
            WHERE Id = :jobId
        ];

        System.assertEquals(cronExp, ct.CronExpression, 'A expressão CRON agendada deve bater com a configurada no teste.');
        System.assertEquals(0, ct.TimesTriggered, 'O job foi apenas agendado, logo não deve ter sido acionado ainda');
    }
}