@isTest
private class OrderTest {

    @TestSetup
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

        //CRIANDO DADOS PARA IMPOSTO
        Tax__c tax = (Tax__c) factory.createSObject(new Tax__c(Distribution_Center__c = DC.Id, State__c = state.Id, Product__c = product.Id, Tax_On_Cost__c = 10));
        insert tax;

        //CRIANDO DADOS PARA MARGEM
        Margin__c margin = (Margin__c) factory.createSObject(new Margin__c(Distribution_Center__c = DC.Id, Account__c = account.Id, Product__c = product.Id, City__c = city.Id, Value__c = 20));
        insert margin;

        //CRIANDO DADOS PARA FRETE
        Freight__c freight = (Freight__c) factory.createSObject(new Freight__c(Distribution_Center__c = DC.Id, City__c = city.Id, Product__c = product.Id, Value__c = 100, Status__c = 'Aprovado'));
        insert freight;

        PricebookEntry pbe = [SELECT Pricebook2Id FROM PricebookEntry WHERE Product2Id = :product.Id LIMIT 1];

        Order order = (Order) factory.createSObject(new Order(AccountId = account.Id, Distribution_Center__c = DC.Id, Payment_Terms__c = paymentTerms.Id, Address__c = accountAddress.Id, Pricebook2Id = pbe.Pricebook2Id));
        insert order;

        OrderItem item = new OrderItem(OrderId = order.Id, Product2Id = product.Id, Quantity = 10, UnitPrice = 1000000, PricebookEntryId = pbe.Id);
        item = (OrderItem) factory.createSObject(item);
        insert item;
    }

    @isTest
    static void validaAlteracoesTest(){

        Order order = [SELECT Id, AccountId, Distribution_Center__c, Payment_Terms__c, Address__c FROM Order LIMIT 1];

        Test.startTest();

        order.Status = 'Activated';
        update order;

        try{
            order.AccountId = null;
            order.Distribution_Center__c = null;
            order.Payment_Terms__c = null;
            order.Address__c = null;
            order.Status = 'Draft';

            update order;
            System.assert(false, 'Não é possível atualizar um pedido que ja está Ativado');
        }
        catch (DmlException e){
            System.assert(e.getDmlMessage(0).contains('Não é possível fazer qualquer alteração em um pedido que está Ativo'), 'Erro: ' + e.getMessage());
        }

        Test.stopTest();
    }

    @isTest
    static void recalculaPrecoTest(){

        Distribution_Center__c DCChanged = new Distribution_Center__c();
        DCChanged = (Distribution_Center__c) TestFactorySObject.getInstance().createSObject(DCChanged);
        insert DCChanged;

        Order order = [SELECT Id FROM Order LIMIT 1];
        order.Distribution_Center__c = DCChanged.Id;

        Test.startTest();

        try{
            update order;
            System.assert(false, 'Não é possível recalcular o preço de um pedido que já está Ativado');
        }
        catch (Exception e){
            System.assert(e.getMessage().contains('Erro ao atualizar o pedido e seus itens devido a falta de parâmetros, entre em contato com o time de pricing.'), 'Erro: ' + e.getMessage());
        }

        Test.stopTest();
    }
}