public with sharing class CadastroDeContas{

    private List<Conta> Contas = new List<Conta>();

    public void AdicionarConta(Conta conta){
        
        if (conta != null){
            Contas.add(conta);
            System.debug('Conta adicionada com sucesso!');
        }
    }

    public void ListarContas(){
        for (Conta conta : Contas){
            System.debug('Conta: ' + conta.numeroConta + ' - ' + conta.nomeTitular + ' - ' + conta.saldo);
        }
    }
        
    public Decimal CalcularTotalTaxas(){
        Decimal totalTaxas = 0;
        
        for (Conta conta : Contas){
            totalTaxas += conta.CalcularTaxa();
        }
        return totalTaxas;
    }

    public List<Conta> BuscarContas(Set<Integer> numerosContas, Map<Integer, Conta> mapaContas){
        List<Conta> contasEncontradas = new List<Conta>();

        for(Integer numero : numerosContas){
            if(mapaContas.containsKey(numero)){
            contasEncontradas.add(mapaContas.get(numero));
            }
        }
        return contasEncontradas;
    }
}