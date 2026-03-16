public List<String> fullNames(List<String> firstNames, List<String> lastNames) {
    
    List<String> names = new List<String>();

    for (Integer i = 0; i < firstNames.size(); i++){
        
        String fullName = firstNames[i] + ' ' + lastNames[i];
        names.add(fullName);
    }

    return names;
}