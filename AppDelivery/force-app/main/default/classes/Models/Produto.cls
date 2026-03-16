public with sharing class Produto {
    
    public String nome { get; set; }
    public Decimal preco { get; set; }

    public Produto(){}

    public Produto(String nome, Decimal preco){
        this.nome = nome;
        this.preco = preco;
    }
}