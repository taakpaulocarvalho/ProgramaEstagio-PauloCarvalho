public with sharing class TaxHandler extends TriggerHandler{
    
    public override void beforeInsert(){
        verifyDuplicity((List<Tax__c>) Trigger.new);
    }

    public override void beforeUpdate(){
        verifyDuplicity((List<Tax__c>) Trigger.new);
    }

    private void verifyDuplicity(List<Tax__c> newTaxes){

        Set<String> newKeys = new Set<String>();
        Set<Id> productIds = new Set<Id>();
        Set<Id> distributionCenterds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();

        //VERIFICA SE EXISTEM CHAVES DUPLICADAS NA LISTA DE TaxS QUE IRAO SER CADASTRADOS  
        for (Tax__c tax : newTaxes){

            String key = generateKey(tax);

            if (newKeys.contains(key)){
                tax.addError('Não é permitido cadastrar Taxs duplicados!');
            }
            newKeys.add(key);


            if (tax.Product__c != null) productIds.add(tax.Product__c);
            if (tax.Distribution_Center__c != null) distributionCenterds.add(tax.Distribution_Center__c);
            if (tax.State__c != null) stateIds.add(tax.State__c);
        }

        //BUSCA DE TaxS PRESENTES NO BANCO
        List<Tax__c> taxesFound = [SELECT Id, Product__c, Distribution_Center__c, State__c 
                                               FROM Tax__c
                                               WHERE Id NOT IN :newTaxes
                                               AND (Product__c IN :productIds)
                                               AND (Distribution_Center__c IN :distributionCenterds)
                                               AND (State__c IN :stateIds)];


        //MAPEIA AS CHAVES DO BANCO                                               
        Set<String> existentKeys = new Set<String>();
        for (Tax__c tax : taxesFound){
            String key = generateKey(tax);
            existentKeys.add(key);
        }

        //VERIFICA SE AS CHVAVES ATUAIS JA ESTAO NO BANCO
        for (Tax__c tax : newTaxes){

            String key = generateKey(tax);
            if (existentKeys.contains(key)){
                tax.addError('Já existe um Tax cadastrado para essa combinação de Produto, Centro de Distribuição e Estado');
            }
        }
    }

    private String generateKey(Tax__c tax){
        return '' + String.valueOf(tax.Product__c) + String.valueOf(tax.Distribution_Center__c) + String.valueOf(tax.State__c);
    }

}