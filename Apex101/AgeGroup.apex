public String ageGroup(Integer n) {
    
    if (n <= 1 && n >= 0){
        return 'Infant';
    }
    else if (n <= 14){
        return 'Child';
    }
    else if (n <= 21){
        return 'Youth';
    }
        
    return 'Adult';
}