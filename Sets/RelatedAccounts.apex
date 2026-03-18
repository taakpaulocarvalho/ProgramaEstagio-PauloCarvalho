public Set<Id> accountIds(List<Opportunity> opps) {
    
    Set<Id> accountOpportunityId = new Set<Id>();

    for (Opportunity opp : opps){
        if (opp.AccountId != null){
            accountOpportunityId.add(opp.AccountId);
        }
    }

    return accountOpportunityId;
}