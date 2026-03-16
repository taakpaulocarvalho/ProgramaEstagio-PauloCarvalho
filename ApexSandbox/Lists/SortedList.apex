public boolean isSorted(List<Integer> numbers) {
    
    if (numbers.size() < 3)
        return true;

    Boolean ascending = true; 
    Boolean descending = true;

    for (Integer i = 0; i < (numbers.size() - 1); i++){

        if (numbers[i] > numbers[i + 1])
            ascending = false;

        if (numbers[i] < numbers[i + 1])
            descending = false;
    }

    return ascending || descending;
}