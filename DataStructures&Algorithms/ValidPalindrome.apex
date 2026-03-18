public Boolean isPalindrome(String str){

    String newStr = str.replaceAll('[^a-zA-Z0-9]', '');
    newStr = newStr.toLowerCase();

    for (Integer i = 0; i < newStr.length(); i++){
        if (newStr.charAt(i) != newStr.charAt((newStr.length() - 1) - i)){
            return false;
        }
    }

    return true;
}