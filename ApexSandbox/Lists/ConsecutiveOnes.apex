public Integer maxConsecutiveOnes(Integer[] numbers) {
    
    Integer consecutiveNums = 0;
    Integer count = 0;

    for (Integer num : numbers){
        count++;
        if (num == 0){
            count = 0;
        }
        else if (count > consecutiveNums){
            consecutiveNums = count;
        }
    }

    return consecutiveNums;
}