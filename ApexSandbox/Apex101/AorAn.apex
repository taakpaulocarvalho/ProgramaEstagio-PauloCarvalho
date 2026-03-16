public String aOrAn(String word) {
    
    Boolean verifyA = word.startsWith('a');
    Boolean verifyE = word.startsWith('e');
    Boolean verifyI = word.startsWith('i');
    Boolean verifyO = word.startsWith('o');
    Boolean verifyU = word.startsWith('u');

    if (verifyA || verifyE || verifyI || verifyO || verifyU){
        return 'an ' + word;
    }
    else{
        return 'a ' + word;
    }    
}