public with sharing class Cliente extends Pessoa{
    
    public Endereco endereco { get; private set; }
    public String telefone { get; private set; }

    public Cliente(String nome, Documento documento, Endereco endereco, String telefone){
        super(nome, documento);
        this.endereco = endereco;
        this.telefone = telefone;
    }

    public override String getTipoPessoa(){
        return 'Cliente';
    }
}