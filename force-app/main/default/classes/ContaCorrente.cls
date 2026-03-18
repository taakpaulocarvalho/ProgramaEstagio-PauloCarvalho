public with sharing class ContaCorrente extends Conta implements Tributavel{

    public ContaCorrente(Integer NumeroConta, String NomeTitular){
        super(NumeroConta, NomeTitular);
    }

    public override Decimal CalcularTaxa(){
        return this.saldo * 0.01;
    }

    public Decimal calcularImposto(){
        return this.saldo * 0.02;
    }
}