trigger DevUserTrigger on DevUser__c (after insert){

    new DevUserHandler().run();
}