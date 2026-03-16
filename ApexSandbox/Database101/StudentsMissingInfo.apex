public List<apxio__Student__c> selectStudentsWithoutContactInfo() {
    
    List<apxio__Student__c> student = [SELECT Id, Name FROM apxio__Student__c
                                    WHERE apxio__Active__c = true
                                    AND (apxio__Phone__c = NULL
                                    OR apxio__Email__c = NULL)
                                    ORDER BY Name];
                                    
    return student;
}