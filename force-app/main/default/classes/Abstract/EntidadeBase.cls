public with sharing abstract class EntidadeBase {
    
    public final UUID id { get; private set; }
    
    protected EntidadeBase(){
        this.id = UUID.randomUUID();
    }

    public Boolean equals(Object obj){
        
        if (obj != null && (obj instanceof EntidadeBase)){
            EntidadeBase entidade = (EntidadeBase) obj;
            return this.id == entidade.id;
        }
        return false;
    }

    public Integer hashCode(){
        return System.hashCode(id);
    }
}