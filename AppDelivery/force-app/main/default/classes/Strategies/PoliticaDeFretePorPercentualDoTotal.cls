public with sharing class PoliticaDeFretePorPercentualDoTotal implements PoliticaDeFrete{
    
    private Decimal percentual;

    public FretePorPercentualDoTotal(Decimal percentual){
        if (percentual == null || percentual <= 0) 
            throw new IllegalArgumentException('O percentual deve ser maior que zero');

        this.percentual = percentual;
    }

    public Dinheiro calcularFrete(Pedido pedido){
        Decimal valorFrete = pedido.total.valorMonetario * (percentual / 100);
        return new Dinheiro(valorFrete);
    }
}