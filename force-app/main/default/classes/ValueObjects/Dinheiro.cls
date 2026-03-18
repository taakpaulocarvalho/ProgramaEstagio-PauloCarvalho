public with sharing class Dinheiro {
    
    public final Decimal valorMonetario { get; private set; }
    
    public Dinheiro(Decimal valorMonetario){
        if (valorMonetario == null || valorMonetario < 0){
            throw new IllegalArgumentException('Valor monetario invalido ou menor que zero!');
        }
        this.valorMonetario = valorMonetario;
    }

    public Dinheiro Somar(Dinheiro dinheiro){
        if (dinheiro == null)
            throw new IllegalArgumentException('Dinheiro invalido!');

        Decimal resultado = this.valorMonetario + dinheiro.valorMonetario;
        return new Dinheiro(resultado);
    }

    public Dinheiro Subtrair(Dinheiro dinheiro){
        if (this.valorMonetario < dinheiro.valorMonetario)
            throw new IllegalArgumentException('Valor monetario invalido!');

        Decimal resultado = this.valorMonetario - dinheiro.valorMonetario;
        return new Dinheiro(resultado);
    }

    public Dinheiro Multiplicar(Integer quantidade){
        if (quantidade == null || quantidade < 0)
            throw new IllegalArgumentException('Quantidade invalida!');
        
        Decimal resultado = this.valorMonetario * quantidade;
        return new Dinheiro(resultado);
    }

    public Boolean equals(Object obj){
        if (obj != null && (obj instanceof Dinheiro)){
            Dinheiro dinheiro = (Dinheiro) obj;
            return this.valorMonetario == dinheiro.valorMonetario;
        }
        return false;
    }

    public Integer hashCode(){
        return System.hashCode(valorMonetario);
    }
}