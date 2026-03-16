public List<sObject> getListOfsObject(List<Account> accounts, List<Contact> contacts)
{
    List<sObject> sObjectsList = new List<sObject>();   

    if (accounts != null){
        for (Account account : accounts){
            sObjectsList.add(account);
        }
    }
    
    if (contacts != null){
        for (Contact contact : contacts){
            sObjectsList.add(contact);
        }
    }
    
    return sObjectsList;
}