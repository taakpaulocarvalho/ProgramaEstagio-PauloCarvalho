public Integer nextPrime(Integer num) {
    
    Integer smallestPrimeNum = 0;

    for (Integer i = (num+1); i < 100; i++){

        if(num <= 1){
            smallestPrimeNum = 2;
        }
        else if (isPrime(i) == true){
            smallestPrimeNum = i;
            break;
        }
    }
    return smallestPrimeNum;
}

public Boolean isPrime(Integer num){

    for (Integer i = 2; i <= (num - 1); i++){
        if ((Math.mod(num, i)) == 0){
            return false;
        }
    }
    return true;
}