public Map<String, Decimal> industrySummary(List<Account> accounts) {
    
    Map<String, Decimal> summary = new Map<String, Decimal>();
    Decimal actualRevenue = 0.0;

    for (Account acc : accounts){
        
        Decimal revenue = acc.AnnualRevenue;

        if (summary.containsKey(acc.Industry)){
            actualRevenue = summary.get(acc.Industry);
            summary.put(acc.Industry, actualRevenue + revenue);
        }
        else{
            summary.put(acc.Industry, acc.AnnualRevenue);
        }
    }
    return summary;
}