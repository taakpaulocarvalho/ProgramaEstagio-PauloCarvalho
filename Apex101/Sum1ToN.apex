public Integer sumToN(Integer n) {
    
    Integer totalSum = 0;

    for (Integer i = 1; i <= n; i++){
        totalSum += i;    
    }
    
    return totalSum;
}