public static Integer arraySum(List<Integer> numbers) {
    
    Integer sum = 0;

    for (Integer i = 0; i < numbers.size(); i++){
        sum += numbers.get(i);
    }
    return sum;
}