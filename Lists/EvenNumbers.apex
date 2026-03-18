public List<Integer> evenNumbers(Integer n) {
    
    List<Integer> numList = new List<Integer>();

    for (Integer i = 2; i <= (n*2); i += 2){
        numList.add(i);
    }

    return numList;
}