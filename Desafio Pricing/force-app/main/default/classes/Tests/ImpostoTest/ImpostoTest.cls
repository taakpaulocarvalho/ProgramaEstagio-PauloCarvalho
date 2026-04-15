@isTest
private class ImpostoTest {

    @TestSetup
    static void makeData(){

        TestFactorySObject factory = TestFactorySObject.getInstance();

        Centro_Distribuicao__c centro = new Centro_Distribuicao__c();
        centro = (Centro_Distribuicao__c) factory.createSObject(centro);
        insert centro;

        Pais__c pais = new Pais__c();
        pais = (Pais__c) factory.createSObject(pais);
        insert pais;

        Estado__c estado = new Estado__c(Pais__c = pais.Id);
        estado = (Estado__c) factory.createSObject(estado);
        insert estado;
        
        Hierarquia_Produto__c hierarquia = new Hierarquia_Produto__c();
        hierarquia = (Hierarquia_Produto__c) factory.createSObject(hierarquia);
        insert hierarquia;

        TriggerHandler.bypass('ProdutoHandler');
        Product2 produto = new Product2(Custo_Producao__c = 50, Hierarquia_Produto__c = hierarquia.Id);
        produto = (Product2) factory.createSObject(produto);
        insert produto;

        Imposto__c imp = (Imposto__c) factory.createSObject(new Imposto__c(Centro_Distribuicao__c = centro.Id, Estado__c = estado.Id, Produto__c = produto.Id, Imposto_Sobre_Custo__c = 10));
        insert imp;
    }
    
    @isTest
    static void duplicateTestInsert(){

            TestFactorySObject factory = TestFactorySObject.getInstance();

            Centro_Distribuicao__c centro = [SELECT Id FROM Centro_Distribuicao__c LIMIT 1];
            Pais__c pais = [SELECT Id FROM Pais__c LIMIT 1];
            Estado__c estado = [SELECT Id FROM Estado__c LIMIT 1];
            Hierarquia_Produto__c hierarquia = [SELECT Id FROM Hierarquia_Produto__c LIMIT 1];
            Product2 prod = [SELECT Id FROM Product2 LIMIT 1];

            Imposto__c imp1 = new Imposto__c(Centro_Distribuicao__c = centro.Id, Estado__c = estado.Id, Produto__c = prod.Id, Imposto_Sobre_Custo__c = 10);
            imp1 = (Imposto__c) factory.createSObject(imp1);

            Test.startTest();
            try{
                insert imp1;
                System.assert(false, 'Duplicidade');
            }
            catch(DmlException e){
                System.assert(e.getDmlMessage(0).contains('Já existe um imposto cadastrado para essa combinação de Produto, Centro de Distribuição e Estado'), 'Erro: ' +  e.getMessage());
            }
            

            //TESTE DE LISTA DE IMPOSTOS DUPLICADOS
            TriggerHandler.bypass('ProdutoHandler');
            Product2 prod2 = new Product2(Custo_Producao__c = 20, Hierarquia_Produto__c = hierarquia.Id);
            prod2 = (Product2) factory.createSObject(prod2);     
            insert prod2;   

            Product2 prod3 = new Product2(Custo_Producao__c = 20, Hierarquia_Produto__c = hierarquia.Id);
            prod3 = (Product2) factory.createSObject(prod3);      
            insert prod3;      

            Imposto__c imp2 = new Imposto__c(Centro_Distribuicao__c = centro.Id, Estado__c = estado.Id, Produto__c = prod2.Id, Imposto_Sobre_Custo__c = 10);
            Imposto__c imp3 = new Imposto__c(Centro_Distribuicao__c = centro.Id, Estado__c = estado.Id, Produto__c = prod2.Id, Imposto_Sobre_Custo__c = 10);
            imp2 = (Imposto__c) factory.createSObject(imp2);
            imp3 = (Imposto__c) factory.createSObject(imp3);
            
            List<Imposto__c> impostos = new List<Imposto__c>{imp2, imp3};

            try{
                insert impostos;
                System.assert(false, 'Duplicidade');
                
            }
            catch(DmlException e){
                System.assert(e.getDmlMessage(0).contains('Não é permitido cadastrar impostos duplicados!'), 'Erro: ' +  e.getMessage());
            }
            Test.stopTest();
    }

    @isTest
    static void DuplicateTestUpdate(){

            TestFactorySObject factory = TestFactorySObject.getInstance();

            Centro_Distribuicao__c centro = [SELECT Id FROM Centro_Distribuicao__c LIMIT 1];
            Pais__c pais = [SELECT Id FROM Pais__c LIMIT 1];
            Estado__c estado = [SELECT Id FROM Estado__c LIMIT 1];
            Hierarquia_Produto__c hierarquia = [SELECT Id FROM Hierarquia_Produto__c LIMIT 1];
            Product2 prod = [SELECT Id FROM Product2 LIMIT 1];

            Centro_Distribuicao__c centro2 = new Centro_Distribuicao__c();
            centro2 = (Centro_Distribuicao__c) factory.createSObject(centro2);
            insert centro2;

            Imposto__c imp1 = new Imposto__c(Centro_Distribuicao__c = centro2.Id, Estado__c = estado.Id, Produto__c = prod.Id, Imposto_Sobre_Custo__c = 10);
            imp1 = (Imposto__c) factory.createSObject(imp1);
            insert imp1;
            
            Test.startTest();
            try{
                imp1.Centro_Distribuicao__c = centro.Id;
                update imp1;
                System.assert(false, 'Duplicidade');
            }
            catch(DmlException e){
                
                System.assert(e.getDmlMessage(0).contains('Já existe um imposto cadastrado para essa combinação de Produto, Centro de Distribuição e Estado'), 'Erro: ' + e.getMessage());
            }
            Test.stopTest();
    }
}