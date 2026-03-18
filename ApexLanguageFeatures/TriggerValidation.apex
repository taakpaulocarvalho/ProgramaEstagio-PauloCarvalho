public void validateInsert(List<Opportunity> opportunities){
    
    for (Opportunity opportunity : opportunities){
        if(opportunity.StageName == 'Closed Won' && String.isBlank(opportunity.Description)){
            opportunity.addError('Description should not be empty for Closed Won opportunity.');
        }
    }
}