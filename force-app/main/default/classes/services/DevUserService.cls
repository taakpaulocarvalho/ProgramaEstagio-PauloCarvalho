public with sharing class DevUserService {

    public static HttpResponse makeRequestToGitHub(DevUser__c devUser){

        // if (devUsers == null || devUsers.isEmpty()) {
        //     System.debug('Sem DevUsers para processar');
        //     return null;
        // }

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        // for (DevUser__c devUser : devUsers){

        request.setEndpoint('https://api.github.com/users/' + devUser.Login__c);
        request.setMethod('GET');

        request.setHeader('Accept', 'application/vnd.github+json');
        request.setHeader('UserAgent', 'Salesforce-Apex-Callout');

        try {

            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {

                System.debug('Payload de Sucesso: ' + response.getBody());
                return response;
            } else{
                System.debug('Error: ' + response.getStatusCode());
                return response;
            }
        }
        catch(Exception e){
            System.debug('Error: ' + e.getMessage());
            return null;
        }
        //}

        //return new HttpResponse();
    }

    @future(callout=true)
    public static void getInformationFromGitHub(List<Id> devUserIds){

        List<DevUser__c> devUsers = [SELECT Id, Login__c FROM DevUser__c WHERE Id = :devUserIds];
        List<DevUser__c> updatedDevUsers = new List<DevUser__c>();
        for (DevUser__c devUser : devUsers){

            HttpResponse response = makeRequestToGitHub(devUser);
    
            DevUser__c updatedDevUser = new DevUser__c(Id = devUser.Id);
            if (response != null && response.getStatusCode() == 200) {
    
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    
                updatedDevUser.ExternalId__c = (Integer) result.get('id');
                System.debug('ExternalId__c:' + updatedDevUser.ExternalId__c);
                updatedDevUser.Type__c = (String) result.get('type');
                System.debug('Type__c:' + updatedDevUser.Type__c);
                updatedDevUser.Bio__c = (String) result.get('bio');
                System.debug('Bio__c:' + updatedDevUser.Bio__c);
            }
            updatedDevUsers.add(updatedDevUser);
        } 
        update updatedDevUsers;
    }
}