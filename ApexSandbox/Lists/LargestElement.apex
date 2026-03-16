public static Integer findLargest(List<Integer> nums) {
	
    Integer largestNum = nums[0];

    for (Integer i = 0; i < nums.size(); i++){
        if (largestNum < nums[i])
            largestNum = nums[i];
    }

    return largestNum;
}