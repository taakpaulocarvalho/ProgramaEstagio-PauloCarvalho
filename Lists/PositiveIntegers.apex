public List<Integer> positiveIntegers(List<Integer> numbers) {
    
    List<Integer> positiveNums = new List<Integer>();

    for (Integer num : numbers){
        if (num > 0){
            positiveNums.add(num);
        }
    }

    return positiveNums;
}