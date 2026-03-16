public Boolean containsDuplicates(List<Integer> nums) {

    Set<Integer> uniqueNums = new Set<Integer>();

    for (Integer num : nums){
        
        if(uniqueNums.contains(num))
            return true;

        uniqueNums.add(num);
    }

    return false;
}