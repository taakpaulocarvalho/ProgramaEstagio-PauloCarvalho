public Integer findTargetCount(List<Integer> nums, Integer target) {
    
    Integer count = 0;

    for (Integer num : nums){
        if (num == target)
            count++;
    }

    return count;
}