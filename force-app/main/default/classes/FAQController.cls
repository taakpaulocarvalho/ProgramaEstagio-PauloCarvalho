public with sharing class FAQController {
    
    @AuraEnabled(cacheable = true)
    public static List<FAQ__c> getFAQs(String searchKey) {
        if (String.isBlank(searchKey) || searchKey == null || searchKey == 'undefined'){
            
            return [
                SELECT Id, Question__c, Answer__c
                FROM FAQ__c
                ORDER BY Question__c ASC
            ];
        }
        
        String key = '%' + searchKey.trim() + '%';
        return [
            SELECT Id, Question__c, Answer__c
            FROM FAQ__c
            WHERE Question__c LIKE :key
            ORDER BY Question__c ASC
        ];
    }
}