public with sharing abstract class Pessoa extends EntidadeBase{
    
    public String nome { get; private set;}
    public final Documento documento { get; private set; }
    
    public Pessoa(String nome, Documento documento){
        super();
        if (String.isBlank(nome)){
            throw new IllegalArgumentException('Nome não pode ser vazio!');
        }
        this.nome = nome;
        this.Documento = documento;
    }

    public abstract String getTipoPessoa();
}