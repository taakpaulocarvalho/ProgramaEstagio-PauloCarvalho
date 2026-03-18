public Decimal average(List<Decimal> numbers){
    
    Decimal avg;
    Decimal sum = 0;

    for (Decimal num : numbers){
        sum += num;
    }

    avg = sum/numbers.size();

    return avg.setScale(2);
}