public with sharing class ProductHandler extends TriggerHandler {
    
    public override void afterInsert(){
        this.createProductPricebook((List<Product2>) Trigger.new);
    }

    //APOS A CRIACAO DE UM PRODUTO, CRIA O REGISTRO DE PRICEBOOKENTRY PARA O PRODUTO NO PRICEBOOK DE CATALOGO
    public void createProductPricebook(List<Product2> novosProdutos){

        //BUSCA O ID DO PRICEBOOK DE CATALOGO PARA CRIAR AS PRICEBOOKENTRY DOS PRODUTOS
        Id idPricebook = Test.isRunningTest() ? Test.getStandardPricebookId() : [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;

        //CRIA LISTA DE PRICEBOOKENTRY PARA INSERIR OS PRODUTOS NO PRICEBOOK
        List<PricebookEntry> productsToCreate = new List<PricebookEntry>();

        //RODA LISTA DE PRODUTOS PARA CRIAR AS PRICEBOOKENTRY PARA CADA PRODUTO
        for (Product2 product : novosProdutos){

            productsToCreate.add(new PricebookEntry(
                Product2Id = product.Id,
                Pricebook2Id = idPricebook,
                UnitPrice = product.Production_Cost__c,
                IsActive = true            
            ));
        }

        if (!productsToCreate.isEmpty()){
            insert productsToCreate;
        }
    }
}