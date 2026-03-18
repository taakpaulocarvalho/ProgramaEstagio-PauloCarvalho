public List<Account> getAccountsFromJSONString(String inputJSON){
    
    if(String.isBlank(inputJSON)){
        return null;
    }
    
    List<Account> accounts = (List<Account>)JSON.deserialize(inputJSON, List<Account>.class);

    return accounts;
}