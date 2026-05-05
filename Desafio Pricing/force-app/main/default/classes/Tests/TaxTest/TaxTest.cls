@isTest
private class TaxTest {

    @TestSetup
    static void makeData(){

        TestFactorySObject factory = TestFactorySObject.getInstance();

        Distribution_Center__c DC = (Distribution_Center__c) factory.createSObject(new Distribution_Center__c());
        insert DC;

        Country__c country = (Country__c) factory.createSObject(new Country__c());
        insert country;

        State__c state = (State__c) factory.createSObject(new State__c(Country__c = country.Id));
        insert state;
        
        Product_Hierarchy__c hierarchy = (Product_Hierarchy__c) factory.createSObject(new Product_Hierarchy__c());
        insert hierarchy;

        TriggerHandler.bypass('ProductHandler');
        Product2 product = (Product2) factory.createSObject(new Product2(Production_Cost__c = 50, Product_Hierarchy__c = hierarchy.Id));
        insert product;

        Tax__c tax = (Tax__c) factory.createSObject(new Tax__c(Distribution_Center__c = DC.Id, State__c = state.Id, Product__c = product.Id, Tax_On_Cost__c = 10));
        insert tax;
    }
    
    @isTest
    static void duplicateTestInsert(){

            TestFactorySObject factory = TestFactorySObject.getInstance();

            Distribution_Center__c DC = [SELECT Id FROM Distribution_Center__c LIMIT 1];
            Country__c country = [SELECT Id FROM Country__c LIMIT 1];
            State__c state = [SELECT Id FROM State__c LIMIT 1];
            Product_Hierarchy__c hierarchy = [SELECT Id FROM Product_Hierarchy__c LIMIT 1];
            Product2 prod = [SELECT Id FROM Product2 LIMIT 1];

            Tax__c tax1 = (Tax__c) factory.createSObject(new Tax__c(Distribution_Center__c = DC.Id, State__c = state.Id, Product__c = prod.Id, Tax_On_Cost__c = 10));

            Test.startTest();
            try{
                insert tax1;
                System.assert(false, 'Duplicidade');
            }
            catch(DmlException e){
                System.assert(e.getDmlMessage(0).contains('Já existe um Tax cadastrado para essa combinação de Produto, Centro de Distribuição e Estado'), 'Erro: ' +  e.getMessage());
            }
            

            //TESTE DE LISTA DE IMPOSTOS DUPLICADOS
            TriggerHandler.bypass('ProductHandler');
            Product2 prod2 = (Product2) factory.createSObject(new Product2(Production_Cost__c = 20, Product_Hierarchy__c = hierarchy.Id));
            insert prod2;   

            Product2 prod3 = (Product2) factory.createSObject(new Product2(Production_Cost__c = 20, Product_Hierarchy__c = hierarchy.Id));
            insert prod3;      

            Tax__c tax2 = new Tax__c(Distribution_Center__c = DC.Id, State__c = state.Id, Product__c = prod2.Id, Tax_On_Cost__c = 10);
            Tax__c tax3 = new Tax__c(Distribution_Center__c = DC.Id, State__c = state.Id, Product__c = prod2.Id, Tax_On_Cost__c = 10);
            tax2 = (Tax__c) factory.createSObject(tax2);
            tax3 = (Tax__c) factory.createSObject(tax3);
            
            List<Tax__c> Taxs = new List<Tax__c>{tax2, tax3};

            try{
                insert Taxs;
                System.assert(false, 'Duplicidade');
                
            }
            catch(DmlException e){
                System.assert(e.getDmlMessage(0).contains('Não é permitido cadastrar Taxs duplicados!'), 'Erro: ' +  e.getMessage());
            }
            Test.stopTest();
    }

    @isTest
    static void DuplicateTestUpdate(){

            TestFactorySObject factory = TestFactorySObject.getInstance();

            Distribution_Center__c DC = [SELECT Id FROM Distribution_Center__c LIMIT 1];
            Country__c country = [SELECT Id FROM Country__c LIMIT 1];
            State__c state = [SELECT Id FROM State__c LIMIT 1];
            Product_Hierarchy__c hierarchy = [SELECT Id FROM Product_Hierarchy__c LIMIT 1];
            Product2 prod = [SELECT Id FROM Product2 LIMIT 1];

            Distribution_Center__c DC2 = (Distribution_Center__c) factory.createSObject(new Distribution_Center__c());
            insert DC2;

            Tax__c tax1 = (Tax__c) factory.createSObject(new Tax__c(Distribution_Center__c = DC2.Id, State__c = state.Id, Product__c = prod.Id, Tax_On_Cost__c = 10));
            insert tax1;
            
            Test.startTest();
            try{
                tax1.Distribution_Center__c = DC.Id;
                update tax1;
                System.assert(false, 'Duplicidade');
            }
            catch(DmlException e){
                
                System.assert(e.getDmlMessage(0).contains('Já existe um Tax cadastrado para essa combinação de Produto, Centro de Distribuição e Estado'), 'Erro: ' + e.getMessage());
            }
            Test.stopTest();
    }
}