public with sharing class DevUserHandler extends TriggerHandler{

    public override void afterInsert() {

        verifyFilledLogin((List<DevUser__c>) Trigger.new, (Map<Id, DevUser__c>) Trigger.oldMap);
    }

    private void verifyFilledLogin(List<DevUser__c> newDevUser, Map<Id, DevUser__c> oldMapDevUser){

        List<Id> devUsersToUpdate = new List<Id>();
        for (DevUser__c devUser : newDevUser) {

            DevUser__c oldDevUser;
            if (oldMapDevUser != null){

                oldDevUser = oldMapDevUser.get(devUser.Id);
            }
            else{
                oldDevUser = null;
            }
            
            Boolean isInsert = (oldDevUser == null);
            Boolean hasLogin = (devUser.Login__c != null);
            Boolean loginChanged = !isInsert && (oldDevUser.Login__c != devUser.Login__c);

            if (hasLogin && (isInsert || loginChanged)){
                
                devUsersToUpdate.add(devUser.Id);
            }
            else if (!hasLogin){
                devUser.addError('Não foi possível buscar as informações do GitHub, pois o campo de Login está vazio.');
            }
            DevUserService.getInformationFromGitHub(devUsersToUpdate);
        }
    }
}