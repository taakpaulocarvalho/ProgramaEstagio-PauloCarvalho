public List<Integer> fibonacciSeries(Integer n) {
    
    List<Integer> fibonacciList = new List<Integer>();

    for (Integer i = 0; i < n; i ++){
        
        if (i < 2){
            fibonacciList.add(1);
        }
        else{
            Integer nextValue = fibonacciList[i - 1] + fibonacciList[i - 2];
            fibonacciList.add(nextValue);
        }
    }

    return fibonacciList;
}