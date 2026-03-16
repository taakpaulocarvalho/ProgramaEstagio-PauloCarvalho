public with sharing class Documento {

    public final String valor { get; private set; }

    public Documento(String valor){
        this.valor = valor;
    }

    public Boolean equals(Object obj){
        if (obj != null && (obj instanceof Documento)){
            Documento documento = (Documento) obj;
            return this.valor == documento.valor;
        }
        return false;
    }

    public Integer hashCode(){
        return System.hashCode(valor);
    }
}