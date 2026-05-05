public with sharing class FreightHandler extends TriggerHandler {
    
    public override void beforeInsert(){
        verifyDuplicity((List<Freight__c>) Trigger.new);
    }

    public override void beforeUpdate(){
        verifyDuplicity((List<Freight__c>) Trigger.new);
    }

    private void verifyDuplicity(List<Freight__c> newFreights){

        Set<String> newKeys = new Set<String>();
        Set<Id> productIds = new Set<Id>();
        Set<Id> hierarchyIds = new Set<Id>();
        Set<Id> distributionCenterds = new Set<Id>();
        Set<Id> CityIds = new Set<Id>();
        Set<Id> StateIds = new Set<Id>();
        Set<Id> CountryIds = new Set<Id>();

        //VERIFICA SE EXISTEM keyS DUPLICADAS NA LISTA DE FreightS QUE IRAO SER CADASTRADOS  
        for (Freight__c freight : newFreights){

            String key = generateKey(Freight);

            if ((newKeys.contains(key))){
                Freight.addError('Não é permitido cadastrar Freights duplicados!');
            }
            newKeys.add(key);

            if (freight.Product__c != null) productIds.add(freight.Product__c);
            if (freight.Product_Hierarchy__c != null) hierarchyIds.add(freight.Product_Hierarchy__c);
            if (freight.Distribution_Center__c != null) distributionCenterds.add(freight.Distribution_Center__c);
            if (freight.City__c != null) CityIds.add(freight.City__c);
            if (freight.State__c != null) StateIds.add(freight.State__c);
            if (freight.Country__c != null) CountryIds.add(freight.Country__c);

            //if (Freight.Id != null) idsFreightsAtualizacao.add(Freight.Id);
        }   


        //BUSCA DE FreightS PRESENTES NO BANCO
        List<Freight__c> freightsFound = [SELECT Id, Product__c, Product_Hierarchy__c, Distribution_Center__c, City__c, State__c, Country__c 
                                            FROM Freight__c
                                            WHERE Id NOT IN :newFreights
                                            AND (Product__c IN :productIds OR Product__c = null)
                                            AND (Product_Hierarchy__c IN :hierarchyIds OR Product_Hierarchy__c = null)
                                            AND (Distribution_Center__c IN :distributionCenterds OR Distribution_Center__c = null)
                                            AND (City__c IN :CityIds OR City__c = null)
                                            AND (State__c IN :StateIds OR State__c = null)
                                            AND (Country__c IN :CountryIds OR Country__c = null)];

        
        //MAPEIA AS CHAVES DO BANCO                                               
        Set<String> existentKeys = new Set<String>();
        for (Freight__c freight : freightsFound){
            String key = generateKey(freight);
            existentKeys.add(key);
        }

        //VERIFICA SE AS CHVAVES ATUAIS JA ESTAO NO BANCO
        for (Freight__c freight : newFreights){

            if(existentKeys.contains(generateKey(freight))){
                Freight.addError('Já existe um Freight cadastrado para essa combinação de Produto, Hierarquia, Centro de Distribuicao, Cidade, Estado, Pais.');
            }
        }
    }

    private String generateKey(Freight__c Freight){
        return '' + String.valueOf(Freight.Product__c) + 
                    String.valueOf(Freight.Product_Hierarchy__c) + 
                    String.valueOf(Freight.Distribution_Center__c) + 
                    String.valueOf(Freight.City__c) +
                    String.valueOf(Freight.State__c) +
                    String.valueof(Freight.Country__c);
                    
    }
}