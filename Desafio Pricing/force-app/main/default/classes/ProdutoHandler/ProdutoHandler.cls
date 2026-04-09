public with sharing class ProdutoHandler extends TriggerHandler {
    
    public override void afterInsert(){
        this.criar((List<Product2>) Trigger.new);
    }

    //APOS A CRIACAO DE UM PRODUTO, CRIA O REGISTRO DE PRICEBOOKENTRY PARA O PRODUTO NO PRICEBOOK DE CATALOGO
    public void criarPricebookProduto(List<Product2> novosProdutos){

        //BUSCA O ID DO PRICEBOOK DE CATALOGO PARA CRIAR AS PRICEBOOKENTRY DOS PRODUTOS
        Pricebook2 catalogo = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];

        //CRIA LISTA DE PRICEBOOKENTRY PARA INSERIR OS PRODUTOS NO PRICEBOOK
        List<PricebookEntry> produtosParaCriar = new List<PricebookEntry>();

        //RODA LISTA DE PRODUTOS PARA CRIAR AS PRICEBOOKENTRY PARA CADA PRODUTO
        for (Product2 produto : novosProdutos){

            produtosParaCriar.add(new PricebookEntry(
                Product2Id = produto.Id,
                Pricebook2Id = catalogo.Id,
                UnitPrice = produto.Custo_Producao__c,
                IsActive = true            
            ));
        }

        if (!produtosParaCriar.isEmpty()){
            insert produtosParaCriar;
        }
    }
}