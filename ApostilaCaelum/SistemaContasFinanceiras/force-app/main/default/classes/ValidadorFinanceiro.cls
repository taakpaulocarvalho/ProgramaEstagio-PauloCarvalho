public with sharing class ValidadorFinanceiro {

    public static void ValidaValor(Decimal valor){
        if(valor <= 0)
            throw new HandledException('Valor deve ser maior que 0!');    
    }
}