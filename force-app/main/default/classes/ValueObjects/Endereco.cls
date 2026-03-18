public with sharing class Endereco {
    
    public final String logradouro { get; private set; }
    public final String complemento { get; private set; }
    public final String numero { get; private set; }
    public final String cidade { get; private set; }

    public Endereco(String logradouro, String numero, String complemento, String cidade){
        this.logradouro = logradouro;
        this.numero = numero;
        this.complemento = complemento;
        this.cidade = cidade;
    }

    public Boolean equals(Object obj){
        if (obj != null && (obj instanceof Endereco)){
            Endereco endereco = (Endereco) obj;
            return this.logradouro == endereco.logradouro &&
                   this.numero == endereco.numero &&
                   this.complemento == endereco.complemento &&
                   this.cidade == endereco.cidade;
        }
        return false;
    }

    public Integer hashCode(){
        return System.hashCode(logradouro + numero + complemento + cidade);
    }
}