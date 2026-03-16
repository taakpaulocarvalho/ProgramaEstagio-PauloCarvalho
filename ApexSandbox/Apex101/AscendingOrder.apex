public Boolean ascendingOrder(Integer a, Integer b, Integer c) {
    
    if (a <= b && a <= c){
        if (b <= c){
            return true;
        }
    }
    return false;
}