@isTest
private class FreteTest {

    @TestSetup
    static void makeData(){
     
        Hierarquia_Produto__c hierarquia = new Hierarquia_Produto__c();
        hierarquia = (Hierarquia_Produto__c) TestFactorySObject.getInstance().createSObject(hierarquia);
        insert hierarquia;

        Centro_Distribuicao__c centro = new Centro_Distribuicao__c();
        centro = (Centro_Distribuicao__c) TestFactorySObject.getInstance().createSObject(centro);
        insert centro;

        Pais__c pais = new Pais__c();
        pais = (Pais__c) TestFactorySObject.getInstance().createSObject(pais);
        insert pais;

        Frete__c frete = new Frete__c(Centro_Distribuicao__c = centro.Id, Pais__c = pais.Id, Hierarquia_Produto__c = hierarquia.Id, Valor__c = 100, Status__c = 'Aprovado');
        frete = (Frete__c) TestFactorySObject.getInstance().createSObject(frete);
        insert frete;
    }

    @isTest
    static void duplicateTestInsert(){

            Centro_Distribuicao__c centro = [SELECT Id FROM Centro_Distribuicao__c LIMIT 1];
            Pais__c pais = [SELECT Id FROM Pais__c LIMIT 1];
            Hierarquia_Produto__c hierarquia = [SELECT Id FROM Hierarquia_Produto__c LIMIT 1];

            Frete__c frete1 = new Frete__c(Centro_Distribuicao__c = centro.Id, Pais__c = pais.Id, Hierarquia_Produto__c = hierarquia.Id, Valor__c = 100, Status__c = 'Aprovado');
            frete1 = (Frete__c) TestFactorySObject.getInstance().createSObject(frete1);

            Test.startTest();
            try{
                insert frete1;
                System.assert(false, 'Duplicidade');
            }
            catch(DmlException e){
                System.assert(e.getDmlMessage(0).contains('Já existe um frete cadastrado para essa combinação de Produto, Hierarquia, Centro de Distribuicao, Cidade, Estado, Pais.'), 'Erro: ' +  e.getMessage());
            }

            //TESTE DE LISTA DE FRETES DUPLICADOS
            Frete__c frete2 = new Frete__c(Centro_Distribuicao__c = centro.Id, Pais__c = pais.Id, Hierarquia_Produto__c = hierarquia.Id, Valor__c = 100, Status__c = 'Aprovado');
            Frete__c frete3 = new Frete__c(Centro_Distribuicao__c = centro.Id, Pais__c = pais.Id, Hierarquia_Produto__c = hierarquia.Id, Valor__c = 100, Status__c = 'Aprovado');
            frete2 = (Frete__c) TestFactorySObject.getInstance().createSObject(frete2);
            frete3 = (Frete__c) TestFactorySObject.getInstance().createSObject(frete3);
            
            List<Frete__c> fretes = new List<Frete__c>{frete2, frete3};
        
            try{
                insert fretes;
                System.assert(false, 'Duplicidade');
            }
            catch(DmlException e){
                System.assert(e.getDmlMessage(0).contains('Já existe um frete cadastrado para essa combinação de Produto, Hierarquia, Centro de Distribuicao, Cidade, Estado, Pais.'), 'Erro: ' +  e.getMessage());
            }
            Test.stopTest();
    }

    @isTest
    static void duplicateTestUpdate(){

            Centro_Distribuicao__c centro = [SELECT Id FROM Centro_Distribuicao__c LIMIT 1];
            Pais__c pais = [SELECT Id FROM Pais__c LIMIT 1];
            Hierarquia_Produto__c hierarquia = [SELECT Id FROM Hierarquia_Produto__c LIMIT 1];

            Centro_Distribuicao__c centro2 = new Centro_Distribuicao__c();
            centro2 = (Centro_Distribuicao__c) TestFactorySObject.getInstance().createSObject(centro2);
            insert centro2;

            Frete__c frete1 = new Frete__c(Centro_Distribuicao__c = centro2.Id, Pais__c = pais.Id, Hierarquia_Produto__c = hierarquia.Id, Valor__c = 100, Status__c = 'Aprovado');
            frete1 = (Frete__c) TestFactorySObject.getInstance().createSObject(frete1);
            insert frete1;

            Test.startTest();
            try{
                frete1.Centro_Distribuicao__c = centro.Id;
                update frete1;
                System.assert(false, 'Duplicidade');
            }
            catch(DmlException e){
                System.assert(e.getDmlMessage(0).contains('Já existe um frete cadastrado para essa combinação de Produto, Hierarquia, Centro de Distribuicao, Cidade, Estado, Pais.'), 'Erro: ' +  e.getMessage());
            }
            Test.stopTest();    
    }
}