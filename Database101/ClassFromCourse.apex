public Id classFromCourse(String courseName) {
    
    List<apxio__Course__c> courses = [SELECT Id, Name FROM apxio__Course__c
                                      WHERE Name = :courseName LIMIT 1];

    if (courses.isEmpty())
        return null;

    apxio__Class__c courseClass = new apxio__Class__c(apxio__Course__c = courses[0].Id,
                                                      Name = courses[0].Name);

    insert courseClass;

    return courseClass.Id;
}