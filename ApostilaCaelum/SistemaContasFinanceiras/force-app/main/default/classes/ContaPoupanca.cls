public with sharing class ContaPoupanca extends Conta{

    public ContaPoupanca(Integer NumeroConta, String NomeTitular){
        super(NumeroConta, NomeTitular);
    }

    public override Decimal CalcularTaxa(){
        return this.saldo *  0.005;
    }
}