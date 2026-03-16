public Map<String, Account> phoneToAccount(List<Account> accounts) {
    
    Map<String, Account> phoneAccountMap = new Map<String, Account>();

    for (Account acc : accounts){
        if (acc.Phone != null){
            phoneAccountMap.put(acc.phone, acc);
        }
    }
    return phoneAccountMap;
}