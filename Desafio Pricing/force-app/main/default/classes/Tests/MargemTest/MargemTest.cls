@isTest
private class MargemTest {

    @TestSetup
    static void makeData() {
        
        TestFactorySObject factory = TestFactorySObject.getInstance();
        
        Hierarquia_Produto__c hierarquia = new Hierarquia_Produto__c();
        hierarquia = (Hierarquia_Produto__c) factory.createSObject(hierarquia);
        insert hierarquia;

        Grupo_Conta__c grupo = new Grupo_Conta__c();
        grupo = (Grupo_Conta__c) factory.createSObject(grupo);
        insert grupo;

        Centro_Distribuicao__c centro = new Centro_Distribuicao__c();
        centro = (Centro_Distribuicao__c) factory.createSObject(centro);
        insert centro;

        Pais__c pais = new Pais__c();
        pais = (Pais__c) factory.createSObject(pais);
        insert pais;

        Margem__c margem = new Margem__c(Centro_Distribuicao__c = centro.Id, Grupo_Conta__c = grupo.Id, Hierarquia_Produto__c = hierarquia.Id, Pais__c = pais.Id, Valor__c = 20);
        margem = (Margem__c) factory.createSObject(margem);
        insert margem;
    }

    @isTest
    static void duplicateTestInsert() {

        TestFactorySObject factory = TestFactorySObject.getInstance();

        Centro_Distribuicao__c centro = [SELECT Id FROM Centro_Distribuicao__c LIMIT 1];
        Grupo_Conta__c grupo = [SELECT Id FROM Grupo_Conta__c LIMIT 1];
        Hierarquia_Produto__c hierarquia = [SELECT Id FROM Hierarquia_Produto__c LIMIT 1];
        Pais__c pais = [SELECT Id FROM Pais__c LIMIT 1];

        Margem__c margem = new Margem__c(Centro_Distribuicao__c = centro.Id, Grupo_Conta__c = grupo.Id, Hierarquia_Produto__c = hierarquia.Id, Pais__c = pais.Id, Valor__c = 20);
        margem = (Margem__c) factory.createSObject(margem);

        Test.startTest();
        try {
            insert margem;
            System.assert(false, 'Duplicidade');
        }
        catch (DmlException e) {
            System.assert(e.getDmlMessage(0).contains('Já existe uma Margem cadastrada para essa combinacao de Produto, Hierarquia, Centro de Distribuicao, Conta, Grupo de Conta, Cidade, Estado, Pais'), 'Erro: ' + e.getMessage());
        }

        //TESTE DE LISTA DE MARGENS DUPLICADAS
        Hierarquia_Produto__c hierarquia2 = new Hierarquia_Produto__c();
        hierarquia2 = (Hierarquia_Produto__c) factory.createSObject(hierarquia2);
        insert hierarquia2;

        Margem__c margem2 = new Margem__c(Centro_Distribuicao__c = centro.Id, Grupo_Conta__c = grupo.Id, Hierarquia_Produto__c = hierarquia2.Id, Pais__c = pais.Id, Valor__c = 30);
        Margem__c margem3 = new Margem__c(Centro_Distribuicao__c = centro.Id, Grupo_Conta__c = grupo.Id, Hierarquia_Produto__c = hierarquia2.Id, Pais__c = pais.Id, Valor__c = 30);

        margem2 = (Margem__c) factory.createSObject(margem2);
        margem3 = (Margem__c) factory.createSObject(margem3); 

        List<Margem__c> margens = new List<Margem__c>{margem2, margem3};

        try{
            insert margens;
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

        Centro_Distribuicao__c centro = [SELECT Id FROM Centro_Distribuicao__c LIMIT 1];
        Grupo_Conta__c grupo = [SELECT Id FROM Grupo_Conta__c LIMIT 1];
        Hierarquia_Produto__c hierarquia = [SELECT Id FROM Hierarquia_Produto__c LIMIT 1];
        Pais__c pais = [SELECT Id FROM Pais__c LIMIT 1];

        Centro_Distribuicao__c centro2 = new Centro_Distribuicao__c();
        centro2 = (Centro_Distribuicao__c) factory.createSObject(centro2);
        insert centro2;

        Margem__c margemUpdate = new Margem__c(Centro_Distribuicao__c = centro2.Id, Grupo_Conta__c = grupo.Id, Hierarquia_Produto__c = hierarquia.Id, Pais__c = pais.Id, Valor__c = 10);
        margemUpdate = (Margem__c) factory.createSObject(margemUpdate);
        insert margemUpdate;

        Test.startTest();
        try {
            margemUpdate.Centro_Distribuicao__c = centro.Id;
            update margemUpdate;
            System.assert(false, 'Duplicidade');
        }
        catch (DmlException e) {
            System.assert(e.getDmlMessage(0).contains('Já existe uma Margem cadastrada para essa combinacao de Produto, Hierarquia, Centro de Distribuicao, Conta, Grupo de Conta, Cidade, Estado, Pais'), 'Erro: ' + e.getMessage());
        }
        Test.stopTest();
    }
}