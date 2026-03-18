public Id insertCourse(String name, String details, Integer credits) {
    
    apxio__Course__c course = new apxio__Course__c();

    course.Name = name;
    course.apxio__Course_Details__c = details;
    
    if (credits > 4 || credits < 0)
        return null;    

    course.apxio__Credits__c = String.valueOf(credits);

    insert course;
    return course.Id;
}