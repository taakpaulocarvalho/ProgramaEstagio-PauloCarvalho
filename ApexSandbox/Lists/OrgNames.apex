public List<String> orgNames(List<String> adjectives, List<String> animals) {
    
    List<String> orgNamesList = new List<String>();

    for (String adjective : adjectives){

        for (String animal : animals){
            orgNamesList.add(adjective + '-' + animal);
        }
    }

    return orgNamesList;
}