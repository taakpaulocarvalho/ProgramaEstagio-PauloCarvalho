public List<apxio__Student__c> selectUnreachableStudents() {
    
    List<apxio__Student__c> student = [SELECT Id, Name FROM apxio__Student__c
                                        WHERE apxio__Email__c = null
                                        AND apxio__Phone__c = null
                                        AND apxio__Active__c = true
                                        ORDER BY Name];

    return student;
}