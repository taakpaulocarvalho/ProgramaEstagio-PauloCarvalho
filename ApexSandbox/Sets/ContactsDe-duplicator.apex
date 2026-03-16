public static List<Contact> ContactDeduplicator(List<Contact> contacts) {

    if (contacts == null)
        return new List<Contact>();

    List<Contact> uniqueContacts = new List<Contact>();
    Set<String> emails = new Set<String>();

    for (Contact contact : contacts){

        String email = contact.Email; 

        if (email == null){
            email = '';
        }
        else{
            email = email.toLowerCase();
        }

        if (!emails.contains(email)){
            
            uniqueContacts.add(contact);
            emails.add(email);
        }
    }
    return uniqueContacts;
}