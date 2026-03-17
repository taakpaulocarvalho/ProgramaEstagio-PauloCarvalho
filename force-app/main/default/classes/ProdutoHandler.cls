public with sharing class ProdutoHandler extends TriggerHandler{

    public override void afterInsert(){
        this.criar((List<Product2>) Trigger.new);
    }

    private void criar(List<Product2> produtos){

        Pricebook2 precosPadrao = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];

        List<CurrencyType> moedasOrg = [SELECT IsoCode FROM CurrencyType WHERE isActive = true];
        
        List<PricebookEntry> precosParaAdicionar = new List<PricebookEntry>();
        
        for (Product2 produto : produtos){

            for (CurrencyType moeda : moedasOrg){

                precosParaAdicionar.add(new PricebookEntry(
                    Product2Id = produto.Id,
                    Pricebook2Id = precosPadrao.Id,
                    UnitPrice = 0,
                    IsActive = true,    
                    CurrencyIsoCode = moeda.IsoCode
                ));
            }

        }

        if (!precosParaAdicionar.isEmpty())
            insert precosParaAdicionar;

    }

}