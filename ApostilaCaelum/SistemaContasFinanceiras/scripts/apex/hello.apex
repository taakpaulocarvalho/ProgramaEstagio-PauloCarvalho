//CONTA CORRENTE
System.debug('CONTA CORRENTE');
ContaCorrente contaCorrente = new ContaCorrente(123456, 'John Doe');
contaCorrente.Depositar(1000);
System.debug('Conta: ' + contaCorrente.numeroConta + ' - ' + contaCorrente.nomeTitular + ' - ' + contaCorrente.saldo);
System.debug('Calculo de taxa: ' + contaCorrente.CalcularTaxa());
System.debug('Calculo de taxa: ' + contaCorrente.CalcularTaxa());
System.debug('Calculo de Imposto: ' + contaCorrente.calcularImposto());
System.debug(' ');
System.debug(' ');

//CONTA POUPANCA
System.debug('CONTA POUPANCA');
ContaPoupanca contaPoupanca = new ContaPoupanca(133456, 'Paulo Carvalho');
contaPoupanca.Depositar(1000);
System.debug('Conta: ' + contaPoupanca.numeroConta + ' - ' + contaPoupanca.nomeTitular + ' - ' + contaPoupanca.saldo);
System.debug('Calculo de taxa: ' + contaPoupanca.CalcularTaxa());
System.debug('Calculo de taxa: ' + contaPoupanca.CalcularTaxa());
System.debug(' ');
System.debug(' ');


//CADASTRO DE CONTAS
System.debug('CADASTRO DE CONTAS');
CadastroDeContas cadContas = new CadastroDeContas();
cadContas.AdicionarConta(contaCorrente);
cadContas.AdicionarConta(ContaPoupanca);
System.debug(' ');
System.debug(' ');

System.debug('LISTAGEM DE CONTAS: ');
cadContas.ListarContas();

System.debug('Calculo de Taxas: ' + cadContas.CalcularTotalTaxas());
System.debug(' ');
System.debug(' ');

//CALCULADORA DE IMPOSTOS
System.debug('CALCULADORA DE IMPOSTOS');
CalculadoraDeImpostos calcImpostos = new CalculadoraDeImpostos();
List<Tributavel> listaTributaveis = new List<Tributavel>();
listaTributaveis.add(contaCorrente);
System.debug(' ');
System.debug(' ');

//SEGURO DE VIDA
System.debug('SEGURO DE VIDA');
SeguroDeVida seguro = new SeguroDeVida();
seguro.calcularImposto();
listaTributaveis.add(seguro);
calcImpostos.CalcularImpostos(listaTributaveis);

System.debug('Total de impostos: ' + calcImpostos.getSomaImpostos());
System.debug('Total de impostos com seguro: ' + calcImpostos.getSomaImpostos());
System.debug(' ');
System.debug(' ');

//VALIDADOR FINANCEIRO
System.debug('VALIDADOR FINANCEIRO');
ValidadorFinanceiro.ValidaValor(100);
System.debug('Total de Contas: ' + Conta.totalContas);
System.debug(' ');
System.debug(' ');


//SALDO INSUFICIENTE EXCEPTION
System.debug('SALDO INSUFICIENTE EXCEPTION');
try{
    ContaCorrente contaCorrenteTeste = new ContaCorrente(123456, 'Alex Silva');
    contaCorrenteTeste.Depositar(900.0);
    contaCorrenteTeste.Sacar(500.0);
}
catch (SaldoInsuficienteException mensagem){
    System.debug('Erro no Saque: ' + mensagem.getMessage());
}

System.debug(' ');
System.debug(' ');

try{
    ContaCorrente contaCorrenteTeste2 = new ContaCorrente(123456, 'Alex Silva');
    contaCorrenteTeste2.Depositar(900.0);
    contaCorrenteTeste2.Sacar(1000.0);
}
catch (SaldoInsuficienteException mensagem){
    System.debug('Erro no Saque: ' + mensagem.getMessage());
}

System.debug(' ');
System.debug(' ');


//LISTA DE CONTAS
//EXERCICIO 19.1
Conta contaCorrente1 = new ContaCorrente(123456, 'Neymar Junior');
contaCorrente1.Depositar(1000.0);
Conta contaCorrente2 = new ContaCorrente(1234, 'Ailton Junior');
contaCorrente2.Depositar(1200.0);
Conta contaPoupanca1 = new ContaPoupanca(1234, 'Cristiano Ronaldo');
contaPoupanca1.Depositar(1400.0);
List<Conta> listaContas = new List<Conta>();
listaContas.add(contaCorrente1);
listaContas.add(contaCorrente2);
listaContas.add(contaPoupanca1);

Decimal totalTaxas = 0;

for (Conta conta : listaContas){
    totalTaxas += conta.CalcularTaxa();
}
System.debug('Total de taxas: ' + totalTaxas);

System.debug(' ');
System.debug(' ');


//EXERCICIO 19.2
Set<Integer> numerosContas = new Set<Integer>();
for (Conta conta : listaContas){
    if(numerosContas.contains(conta.numeroConta)){
        System.debug('Já existe uma conta com esse numero: ' + conta.numeroConta);
    }
    else{
        numerosContas.add(conta.numeroConta);
    }
}

System.debug('Total de contas iniciais: ' + listaContas.size());
System.debug('Total de contas armazenadas de forma validada: ' + numerosContas.size());
System.debug(' ');
System.debug(' ');


//EXERCICIO 19.3
Map<Integer, Conta> mapaContas = new Map<Integer, Conta>();
mapaContas.put(contaCorrente1.numeroConta, contaCorrente1);
mapaContas.put(contaCorrente2.numeroConta, contaCorrente2);
mapaContas.put(contaPoupanca1.numeroConta, contaPoupanca1);

Conta contaRecuperada = mapaContas.get(1234);
System.debug('Conta recuperada: ');
System.debug('Titular: ' + contaRecuperada.NomeTitular + ' - Numero da conta: ' + contaRecuperada.numeroConta +
' - Saldo: ' + contaRecuperada.saldo);
System.debug(' ');
System.debug(' ');


//EXERCICIO 19.4
List<Conta> contasEncontradas = cadContas.BuscarContas(numerosContas, mapaContas);

for(Conta contaEncontrada : contasEncontradas){
    System.debug('Conta Encontrada: ');
    System.debug('Titular: ' + contaEncontrada.NomeTitular + ' - Numero da conta: ' + contaEncontrada.numeroConta +
' - Saldo: ' + contaEncontrada.saldo);
}
System.debug(' ');
System.debug(' ');
