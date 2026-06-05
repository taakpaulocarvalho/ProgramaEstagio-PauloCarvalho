@isTest
private class MarginTest {

    @TestSetup
    static void makeData() {
        
        TestFactorySObject factory = TestFactorySObject.getInstance();
        
        Product_Hierarchy__c hierarchy = (Product_Hierarchy__c) factory.createSObject(new Product_Hierarchy__c());
        insert hierarchy;

        Account_Group__c accountGroup = (Account_Group__c) factory.createSObject(new Account_Group__c());
        insert accountGroup;

        Distribution_Center__c DC = (Distribution_Center__c) factory.createSObject(new Distribution_Center__c());
        insert DC;

        Country__c country = (Country__c) factory.createSObject(new Country__c());
        insert country;

        Margin__c margin = (Margin__c) factory.createSObject(new Margin__c(Distribution_Center__c = DC.Id, Account_Group__c = accountGroup.Id, Product_Hierarchy__c = hierarchy.Id, Country__c = country.Id, Value__c = 20));
        insert margin;
    }

    @isTest
    static void duplicateTestInsert() {

        TestFactorySObject factory = TestFactorySObject.getInstance();

        Distribution_Center__c DC = [SELECT Id FROM Distribution_Center__c LIMIT 1];
        Account_Group__c accountGroup = [SELECT Id FROM Account_Group__c LIMIT 1];
        Product_Hierarchy__c hierarchy = [SELECT Id FROM Product_Hierarchy__c LIMIT 1];
        Country__c country = [SELECT Id FROM Country__c LIMIT 1];

        Margin__c margin = new Margin__c(Distribution_Center__c = DC.Id, Account_Group__c = accountGroup.Id, Product_Hierarchy__c = hierarchy.Id, Country__c = country.Id, Value__c = 20);
        margin = (Margin__c) factory.createSObject(margin);

        Test.startTest();
        try {
            insert margin;
            System.assert(false, 'Duplicidade');
        }
        catch (DmlException e) {
            System.assert(e.getDmlMessage(0).contains('Já existe uma Margin cadastrada para essa combinacao de Product, Hierarquia, Centro de Distribuicao, Conta, Grupo de Conta, Cidade, Estado, Pais'), 'Erro: ' + e.getMessage());
        }

        //TESTE DE LISTA DE MARGENS DUPLICADAS
        Product_Hierarchy__c hierarchy2 = (Product_Hierarchy__c) factory.createSObject(new Product_Hierarchy__c());
        insert hierarchy2;

        Margin__c margin2 = new Margin__c(Distribution_Center__c = DC.Id, Account_Group__c = accountGroup.Id, Product_Hierarchy__c = hierarchy2.Id, Country__c = country.Id, Value__c = 30);
        Margin__c margin3 = new Margin__c(Distribution_Center__c = DC.Id, Account_Group__c = accountGroup.Id, Product_Hierarchy__c = hierarchy2.Id, Country__c = country.Id, Value__c = 30);

        margin2 = (Margin__c) factory.createSObject(margin2);
        margin3 = (Margin__c) factory.createSObject(margin3); 

        List<Margin__c> margins = new List<Margin__c>{margin2, margin3};

        try{
            insert margins;
            System.assert(false, 'Duplicidade');
        }
        catch (DmlException e) {
            System.assert(e.getDmlMessage(0).contains('Não é permitido cadastrar margens duplicadas!'), 'Erro: ' + e.getMessage());
        }

        Test.stopTest();
    }

    @isTest
    static void duplicateTestUpdate() {

        TestFactorySObject factory = TestFactorySObject.getInstance();

        Distribution_Center__c DC = [SELECT Id FROM Distribution_Center__c LIMIT 1];
        Account_Group__c accountGroup = [SELECT Id FROM Account_Group__c LIMIT 1];
        Product_Hierarchy__c hierarchy = [SELECT Id FROM Product_Hierarchy__c LIMIT 1];
        Country__c country = [SELECT Id FROM Country__c LIMIT 1];

        Distribution_Center__c DC2 = (Distribution_Center__c) factory.createSObject(new Distribution_Center__c());
        insert DC2;

        Margin__c marginUpdate = (Margin__c) factory.createSObject(new Margin__c(Distribution_Center__c = DC2.Id, Account_Group__c = accountGroup.Id, Product_Hierarchy__c = hierarchy.Id, Country__c = country.Id, Value__c = 10));
        insert marginUpdate;

        Test.startTest();
        try {
            marginUpdate.Distribution_Center__c = DC.Id;
            update marginUpdate;
            System.assert(false, 'Duplicidade');
        }
        catch (DmlException e) {
            System.assert(e.getDmlMessage(0).contains('Já existe uma Margin cadastrada para essa combinacao de Product, Hierarquia, Centro de Distribuicao, Conta, Grupo de Conta, Cidade, Estado, Pais'), 'Erro: ' + e.getMessage());
        }
        Test.stopTest();
    }
}