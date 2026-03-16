public with sharing class PoliticaDeFreteFixo implements PoliticaDeFrete {
    
    private Dinheiro valorFixo;

    public FreteFixo(Dinheiro valorFixo){
        this.valorFixo = valorFixo;
    }

    public Dinheiro calcularFrete(Pedido pedido){
        return this.valorFixo;
    }
}