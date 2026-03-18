public with sharing class PoliticaPrecoPadrao implements PoliticaDePreco{
    
    public PoliticaPrecoPadrao(){}

    public Dinheiro calcularPreco(Produto produto){
        return produto.precoBase;
    }
}