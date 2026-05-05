@isTest
private class FreightTest {

    @TestSetup
    static void makeData(){
     
        TestFactorySObject factory = TestFactorySObject.getInstance();

        Product_Hierarchy__c hierarchy = (Product_Hierarchy__c) factory.createSObject(new Product_Hierarchy__c());
        insert hierarchy;

        Distribution_Center__c CD = (Distribution_Center__c) factory.createSObject(new Distribution_Center__c());
        insert CD;

        Country__c country = (Country__c) factory.createSObject(new Country__c());
        insert country;

        Freight__c Freight = (Freight__c) factory.createSObject(new Freight__c(Distribution_Center__c = CD.Id, Country__c = country.Id, Product_Hierarchy__c = hierarchy.Id, Value__c = 100, Status__c = 'Aprovado'));
        insert Freight;
    }

    @isTest
    static void duplicateTestInsert(){

        TestFactorySObject factory = TestFactorySObject.getInstance();

        Distribution_Center__c CD = [SELECT Id FROM Distribution_Center__c LIMIT 1];
        Country__c country = [SELECT Id FROM Country__c LIMIT 1];
        Product_Hierarchy__c hierarchy = [SELECT Id FROM Product_Hierarchy__c LIMIT 1];

        Freight__c freight1 = new Freight__c(Distribution_Center__c = CD.Id, Country__c = country.Id, Product_Hierarchy__c = hierarchy.Id, Value__c = 100, Status__c = 'Aprovado');
        freight1 = (Freight__c) factory.createSObject(freight1);

        Test.startTest();
        try{
            insert freight1;
            System.assert(false, 'Duplicidade');
        }
        catch(DmlException e){
            System.assert(e.getDmlMessage(0).contains('Já existe um Freight cadastrado para essa combinação de Produto, Hierarquia, Centro de Distribuicao, Cidade, Estado, Pais.'), 'Erro: ' +  e.getMessage());
        }

        //TESTE DE LISTA DE FreightS DUPLICADOS
        Freight__c freight2 = new Freight__c(Distribution_Center__c = CD.Id, Country__c = country.Id, Product_Hierarchy__c = hierarchy.Id, Value__c = 100, Status__c = 'Aprovado');
        Freight__c freight3 = new Freight__c(Distribution_Center__c = CD.Id, Country__c = country.Id, Product_Hierarchy__c = hierarchy.Id, Value__c = 100, Status__c = 'Aprovado');
        freight2 = (Freight__c) factory.createSObject(freight2);
        freight3 = (Freight__c) factory.createSObject(freight3);
        
        List<Freight__c> freights = new List<Freight__c>{freight2, freight3};
    
        try{
            insert freights;
            System.assert(false, 'Duplicidade');
        }
        catch(DmlException e){
            System.assert(e.getDmlMessage(0).contains('Já existe um Freight cadastrado para essa combinação de Produto, Hierarquia, Centro de Distribuicao, Cidade, Estado, Pais.'), 'Erro: ' +  e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void duplicateTestUpdate(){

        TestFactorySObject factory = TestFactorySObject.getInstance();

        Distribution_Center__c CD = [SELECT Id FROM Distribution_Center__c LIMIT 1];
        Country__c country = [SELECT Id FROM Country__c LIMIT 1];
        Product_Hierarchy__c hierarchy = [SELECT Id FROM Product_Hierarchy__c LIMIT 1];

        Distribution_Center__c CD2 = new Distribution_Center__c();
        CD2 = (Distribution_Center__c) TestFactorySObject.getInstance().createSObject(CD2);
        insert CD2;

        Freight__c freight = (Freight__c) factory.createSObject(new Freight__c(Distribution_Center__c = CD2.Id, Country__c = country.Id, Product_Hierarchy__c = hierarchy.Id, Value__c = 100, Status__c = 'Aprovado'));
        insert freight;

        Test.startTest();
        try{
            freight.Distribution_Center__c = CD.Id;
            update freight;
            System.assert(false, 'Duplicidade');
        }
        catch(DmlException e){
            System.assert(e.getDmlMessage(0).contains('Já existe um Freight cadastrado para essa combinação de Produto, Hierarquia, Centro de Distribuicao, Cidade, Estado, Pais.'), 'Erro: ' +  e.getMessage());
        }
        Test.stopTest();    
    }
}