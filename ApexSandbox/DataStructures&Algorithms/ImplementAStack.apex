public class Stack {
    
    List<Object> newList = new List<Object>();

    public void push(Object obj) {
        
        newList.add(obj);
    }
    
    public Object pop() {
        if (newList.isEmpty())
            return null;

        return newList.remove(newList.size() - 1);
    }
    
    public Integer size() {
        
        return newList.size();
    }
    
    public Object peek(){
        if (newList.isEmpty())
            return null;

        return newList.get(newList.size() - 1);
    }
    
    public Boolean isEmpty() {
        
        return newList.isEmpty();
    }
}