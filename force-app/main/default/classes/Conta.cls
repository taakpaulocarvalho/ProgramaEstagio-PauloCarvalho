public with sharing abstract class Conta {

    public Integer numeroConta { get; set; }
    public String nomeTitular { get; set; }
    public Decimal saldo { get; set; }
    public static Integer totalContas = 0;

    public Conta(Integer NumeroConta, String NomeTitular){
        this.numeroConta = NumeroConta;
        this.nomeTitular = NomeTitular;
        this.saldo = 0;

        totalContas++;
    }

    public void Depositar(Decimal valor){
        ValidadorFinanceiro.ValidaValor(valor);
    
        saldo += valor;
        System.debug('Valor depositado com sucesso!!!');
        System.debug('Saldo atual: ' + saldo);
    }

    public abstract Decimal CalcularTaxa();

    public void Sacar(Decimal valor){
        ValidadorFinanceiro.ValidaValor(valor);

        if(valor > this.saldo){
            throw new SaldoInsuficienteException('Saldo insuficiente para saque. Saldo atual: ' + this.saldo);
        }

        this.saldo -= valor;
        System.debug('Valor sacado com sucesso!!!');
        System.debug('Saldo atual após o Saque: ' + this.saldo);
    }
}