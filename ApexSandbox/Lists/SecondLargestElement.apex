public Integer secondLargest(List<Integer> numbers) {
    
    Integer largestNum = -2147483647 - 1;
    Integer secondLargestNum = -2147483647 - 1;

    for (Integer num: numbers){

        if (num > largestNum){
            secondLargestNum = largestNum;
            largestNum = num;
        }
        else if (num > secondLargestNum && num < largestNum){
            secondLargestNum = num;
        }
    }

    return secondLargestNum;
}