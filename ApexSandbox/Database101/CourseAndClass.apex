public void createCourseAndClass(String name, String description) {
    
    if (description == null)
        description = ' ';

    apxio__Course__c course = new apxio__Course__c
                                    (Name = name, 
                                     apxio__Course_Details__c = description);

    insert course;

    description = description.left(255);

    apxio__Class__c courseClass = new apxio__Class__c 
                                    (apxio__Course__c = course.Id,
                                     Name = name,
                                     apxio__Description__c = description);

    insert courseClass;
}