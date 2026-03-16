public Map<String, String> phonebook(List<Contact> contacts) {
    
    Map<String, String> mapPhonebook = new Map<String, String>();

    for (Contact con : contacts){
        if(con.Phone != null){
            mapPhonebook.put(con.Name, con.Phone);
        }
    }
    return mapPhonebook;
}