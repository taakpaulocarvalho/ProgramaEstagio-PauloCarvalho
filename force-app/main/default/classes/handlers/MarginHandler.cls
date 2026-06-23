public with sharing class MarginHandler extends TriggerHandler{
    
    public override void beforeInsert(){
        verifyDuplicity((List<Margin__c>) Trigger.new);
    }
    
    public override void beforeUpdate(){
        verifyDuplicity((List<Margin__c>) Trigger.new);
    }

    private void verifyDuplicity(List<Margin__c> newMargins){

        Set<String> newKeys = new Set<String>();
        Set<Id> productIds = new Set<Id>();
        Set<Id> hierarchyIds = new Set<Id>();
        Set<Id> distributionCenterds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> accountGroupIds = new Set<Id>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();


        //VERIFICA SE EXISTEM CHAVES DUPLICADAS NA LISTA DE MARGENS QUE IRAO SER CADASTRADOS 
        for (Margin__c margin : newMargins){

            String key = generateKey(margin);

            if (newKeys.contains(key)){
                margin.addError('Não é permitido cadastrar margens duplicadas!');
            }
            newKeys.add(key);

            if (margin.Product__c != null) productIds.add(margin.Product__c);
            if (margin.Product_Hierarchy__c != null) hierarchyIds.add(margin.Product_Hierarchy__c);
            if (margin.Distribution_Center__c != null) distributionCenterds.add(margin.Distribution_Center__c);
            if (margin.Account__c != null) accountIds.add(margin.Account__c);
            if (margin.Account_Group__c != null) accountGroupIds.add(margin.Account_Group__c);
            if (margin.City__c != null) cityIds.add(margin.City__c);
            if (margin.State__c != null) stateIds.add(margin.State__c);
            if (margin.Country__c != null) countryIds.add(margin.Country__c);
        }

        //BUSCA DE MARGENS PRESENTES NO BANCO
        List<Margin__c> marginsFound = [SELECT Id, Product__c, Product_Hierarchy__c, Distribution_Center__c, Account__c, Account_Group__c, City__c, State__c, Country__c 
                                            FROM Margin__c
                                            WHERE Id NOT IN :newMargins
                                            AND (Product__c IN :productIds OR Product__c = null) 
                                            AND (Product_Hierarchy__c IN :hierarchyIds OR Product_Hierarchy__c = null) 
                                            AND (Distribution_Center__c IN :distributionCenterds OR Distribution_Center__c = null)
                                            AND (Account__c IN :accountIds OR Account__c = null)
                                            AND (Account_Group__c IN :accountGroupIds OR Account_Group__c = null)
                                            AND (City__c IN :cityIds OR City__c = null)
                                            AND (State__c IN :stateIds OR State__c = null)
                                            AND (Country__c IN :countryIds OR Country__c = null)];

        //MAPEIA AS CHAVES DO BANCO       
        Set<String> existentKeys = new Set<String>();
        for (Margin__c margin : marginsFound){
            String key = generateKey(margin);
            existentKeys.add(key);
        }

        //VERIFICA SE AS CHVAVES ATUAIS JA ESTAO NO BANCO
        for (Margin__c margin : newMargins){
            if (existentKeys.contains(generateKey(margin))){
                margin.addError('Já existe uma Margin cadastrada para essa combinacao de Product, Hierarquia, Centro de Distribuicao, Conta, Grupo de Conta, Cidade, Estado, Pais');
            }
        }
    }

    private String generateKey(Margin__c margin){
        return '' + String.valueOf(margin.Product__c) + 
                    String.valueOf(margin.Product_Hierarchy__c) + 
                    String.valueOf(margin.Distribution_Center__c) + 
                    String.valueOf(margin.Account__c) +
                    String.valueOf(margin.Account_Group__c) +
                    String.valueOf(margin.City__c) +
                    String.valueOf(margin.State__c) +
                    String.valueof(margin.Country__c);
    }
}