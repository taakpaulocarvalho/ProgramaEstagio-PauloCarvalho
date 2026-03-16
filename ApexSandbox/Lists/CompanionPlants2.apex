public Boolean companionPlants(List<String> plants) {
    
    if (plants.size() == 1){
        return false;
    }

    for (Integer i = 0; i < plants.size() - 1; i++){
        
        String plant1 = plants[i];
        String plant2 = plants[i+1];

        if(String.isBlank(plant2))
            return false;

        if (!isCompanion(plant1, plant2)){
            return false;
        }
    }

    return true;
}

public Boolean isCompanion(String plant1, String plant2){
    if(plant1 == 'onions' && (plant2 == 'lettuce' || 
                              plant2 == 'carrots' ||
                              plant2 == 'tomatoes'))
    {                            
        return true;
    }
    else if (plant1 == 'lettuce' && (plant2 == 'cucumbers' || 
                           plant2 == 'onions'))
    {
        return true;
    }
    else if (plant1 == 'cucumbers' && plant2 == 'lettuce'){
        return true;
    }
    else if (plant1 == 'carrots' && plant2 == 'onions'){
        return true;
    }
    else if (plant1 == 'tomatoes' && plant2 == 'onions'){
        return true;
    }
    return false;
}