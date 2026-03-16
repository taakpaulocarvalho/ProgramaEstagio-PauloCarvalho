public Map<String, List<Case>> casesByType(List<Case> cases) {
    Map<String, List<Case>> myMap = new Map<String, List<Case>>();
    
    for (Case myCase : cases){
        if (myCase.Type == null) continue;
        
        myMap.put(myCase.Type, myMap.containsKey(myCase.Type) ? myMap.get(myCase.Type) : new List<Case>());
        myMap.get(myCase.Type).add(myCase);
    }
    return myMap;
}