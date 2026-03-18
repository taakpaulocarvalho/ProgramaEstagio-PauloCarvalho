public Boolean sameParent(Account acc, Contact con, Opportunity opp) {
    
    if (con.AccountId == null || opp.AccountId == null)
        return false;
    
    if ((con.AccountId == opp.AccountId) && (acc.Id == con.AccountId) && (acc.Id == opp.AccountId))
        return true;

    return false;
}