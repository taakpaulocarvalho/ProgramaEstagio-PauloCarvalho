public with sharing class CalculadoraDeImpostos {

    Decimal totalImpostos = 0;

    public Decimal CalcularImpostos(List<Tributavel> listaTributavel){
        
        for (Tributavel tributavel : listaTributavel){
            this.totalImpostos += tributavel.calcularImposto();
        }

        return totalImpostos;
    }

    public double getSomaImpostos(){
        return this.totalImpostos;
    }

}