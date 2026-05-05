
@isTest
private class OrderItemTest {

    @TestSetup
    static void makeData() {
        
        TestFactorySObject factory = TestFactorySObject.getInstance();

        Account_Group__c accountGroup = (Account_Group__c) factory.createSObject(new Account_Group__c());
        insert accountGroup;

        Account account = (Account) factory.createSObject(new Account(Customer_Group__c = accountGroup.Id));
        insert account;

        Country__c country = (Country__c) factory.createSObject(new Country__c());
        insert country;

        State__c state = (State__c) factory.createSObject(new State__c(Country__c = country.Id));
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

        Product2 product = (Product2) factory.createSObject(new Product2(Product_Hierarchy__c = productHierarchy.Id, Production_Cost__c = 0));
        insert product;

        //CRIANDO DADOS PARA IMPOSTO
        Tax__c tax = (Tax__c) factory.createSObject(new Tax__c(Distribution_Center__c = DC.Id, State__c = state.Id, Product__c = product.Id, Tax_On_Cost__c = 10));
        insert tax;

        //CRIANDO DADOS PARA MARGEM
        Margin__c margin = (Margin__c) factory.createSObject(new Margin__c(Distribution_Center__c = DC.Id, Account__c = account.Id, Product__c = product.Id, City__c = city.Id, Value__c = 20));
        insert margin;

        Margin__c margin2 = (Margin__c) factory.createSObject(new Margin__c(Distribution_Center__C = DC.Id, Account__c = account.Id, Product_Hierarchy__c = productHierarchy.Id, State__c = state.Id, Value__c = 40));
        insert margin2;

        Margin__c margin3 = (Margin__c) factory.createSObject(new Margin__c(Distribution_Center__C = DC.Id, Account__c = account.Id, Product_Hierarchy__c = productHierarchy.Id, Country__c = country.Id, Value__c = 40));
        insert margin3;

        //CRIANDO DADOS PARA FRETE
        Freight__c freight = (Freight__c) factory.createSObject(new Freight__c(Distribution_Center__c = DC.Id, City__c = city.Id, Product__c = product.Id, Value__c = 0, Status__c = 'Aprovado'));
        insert freight;

        Freight__c freight2 = (Freight__c) factory.createSObject(new Freight__c(Distribution_Center__c = DC.Id, State__c = state.Id, Product_Hierarchy__c = productHierarchy.Id, Value__c = 10, Status__c = 'Aprovado'));
        insert freight2;

        Freight__c freight3 = (Freight__c) factory.createSObject(new Freight__c(Distribution_Center__c = DC.Id, Country__c = country.Id, Product_Hierarchy__c = productHierarchy.Id, Value__c = 10, Status__c = 'Aprovado'));
        insert freight3;

        PricebookEntry pbe = [SELECT Pricebook2Id FROM PricebookEntry WHERE Product2Id = :product.Id LIMIT 1];

        //CRIANDO ORDER
        Order order = new Order(AccountId = account.Id, Distribution_Center__c = DC.Id, Payment_Terms__c = paymentTerms.Id, Address__c = accountAddress.Id, Pricebook2Id = pbE.Pricebook2Id);
        order = (Order) factory.createSObject(order);
        insert order;
    }

    @isTest
    static void calculatePriceZeroTest(){

        TestFactorySObject factory = TestFactorySObject.getInstance();

        Order order = [SELECT Id FROM Order LIMIT 1];
        Product2 product = [SELECT Id FROM Product2 LIMIT 1];   
        PricebookEntry pbe = [SELECT Id from PricebookEntry LIMIT 1];

        OrderItem item = new OrderItem(OrderId = order.Id, Product2Id = product.Id, Quantity = 10, UnitPrice = 50, PricebookEntryId = pbe.Id);
        item = (OrderItem) TestFactorySObject.getInstance().createSObject(item);
        

        Test.startTest();
        try{
            insert item;
            OrderItem itemFound = [SELECT Id, Final_Price__c FROM OrderItem LIMIT 1];
            System.assertEquals(itemFound.Final_Price__c, 0);
        }
        catch (Exception e){
            System.assert(e.getMessage().contains('Erro ao inserir o pedido e seus itens devido a falta de parâmetros, entre em contato com o time de pricing.'), 'Erro: ' + e.getMessage());
        }

        Test.stopTest();
    }

    @isTest
    static void calculateDiscountPriceGreaterThanZeroTest(){

        TestFactorySObject factory = TestFactorySObject.getInstance();

        Account account = [SELECT Id FROM Account LIMIT 1];
        Distribution_Center__c DC = [SELECT Id FROM Distribution_Center__c LIMIT 1];
        Product_Hierarchy__c productHierarchy = [SELECT Id FROM Product_Hierarchy__c LIMIT 1];
        Country__c country = [SELECT Id FROM Country__c LIMIT 1];
        State__c state = [SELECT Id FROM State__c LIMIT 1];
        City__c city = [SELECT Id FROM City__c LIMIT 1];
        Payment_Terms__c paymentTerms = [SELECT Id FROM Payment_Terms__c LIMIT 1];
        Account_Address__c accountAddress = [SELECT Id FROM Account_Address__c LIMIT 1];
        
        Product2 product = (Product2) factory.createSObject(new Product2(Product_Hierarchy__c = productHierarchy.Id, Production_Cost__c = 100));
        insert product;

        PricebookEntry pbe = [SELECT Pricebook2Id FROM PricebookEntry WHERE Product2Id = :product.Id LIMIT 1];

        Freight__c freight = (Freight__c) factory.createSObject(new Freight__c(Distribution_Center__c = DC.Id, Country__c = country.Id, Product__c = product.Id, Value__c = 10, Status__c = 'Aprovado'));
        insert freight;

        Tax__c tax = (Tax__c) factory.createSObject(new Tax__c(Distribution_Center__c = DC.Id, State__c = state.Id, Product__c = product.Id, Tax_On_Cost__c = 10));
        insert tax;

        Margin__c margin = (Margin__c) factory.createSObject(new Margin__c(Distribution_Center__c = DC.Id, Account__c = account.Id, Product__c = product.Id, Country__c = country.Id, Value__c = 20)) ;
        insert margin;

        Order order = (Order) factory.createSObject(new Order(AccountId = account.Id, Distribution_Center__c = DC.Id, Payment_Terms__c = paymentTerms.Id, Address__c = accountAddress.Id, Pricebook2Id = pbe.Pricebook2Id)); 
        insert order;

        OrderItem item = (OrderItem) factory.createSObject(new OrderItem(OrderId = order.Id, Product2Id = product.Id, Quantity = 10, UnitPrice = 50, PricebookEntryId = pbe.Id));
        
        Test.startTest();
        try{
            insert item;
            OrderItem itemFound = [SELECT Id, Discount__c FROM OrderItem LIMIT 1];
            System.Assert(itemFound.Discount__c > 0, 'O desconto deveria ser maior que zero.');
        }
        catch (Exception e){
            System.assert(e.getMessage().contains('Erro ao inserir o pedido e seus itens devido a falta de parâmetros, entre em contato com o time de pricing.'), 'Erro: ' + e.getMessage());
        }

        Test.stopTest();
    }
}