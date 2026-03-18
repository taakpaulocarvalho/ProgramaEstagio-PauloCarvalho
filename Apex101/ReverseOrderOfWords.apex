public String reverseWordsInASentence(String sentence){
    
    if (sentence == null)
        return null;

    String[] splitWords = sentence.split(' ');
    List<String> reversedWords = new List<String>();  
    Integer numWords = splitWords.size();

    for (Integer i = (numWords - 1); i >= 0; i--){
        reversedWords.add(splitWords[i]);
    }  

    return String.join(reversedWords, ' ');
}