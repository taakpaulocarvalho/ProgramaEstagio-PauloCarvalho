public String divide(Integer a, Integer b){
    
    Integer result = 0;

    try{
        result = a / b;
    }
    catch(Exception e){
        return e.getMessage();
    }

    return String.valueOf(result);
}