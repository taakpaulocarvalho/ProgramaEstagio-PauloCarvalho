public Boolean isEndWithZero(Integer num){

    if ((num == 0) || (Math.mod(num, 10) == 0)){
        return true;
    }
    return false;
}