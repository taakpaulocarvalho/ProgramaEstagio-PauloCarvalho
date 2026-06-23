global class GoalBatch implements Database.Batchable<SObject>, Schedulable {


    global Database.QueryLocator start(Database.BatchableContext bc){    

        System.debug('Iniciando o método start');
        Integer actualYear = Date.today().year();
        
        return Database.getQueryLocator(
            [SELECT Id, Name, Year__c, Commission_Percentage__c, Commission_Value__c, Sales_Value__c, Seller__c FROM Goal__c WHERE Year__c = :actualYear]
        );
    }

    global void execute (Database.BatchableContext bc, List<Goal__c> scope){

        System.debug('Iniciando o método execute');
        GoalCalculationService.calculateGoals(scope);

    }

    global void finish(Database.BatchableContext bc) {

        System.debug('Processamento de metas finalizado via Batch');
    }

    global void execute(SchedulableContext sc){

        GoalBatch gb = new GoalBatch();
        Database.executeBatch(gb, 50);
        
    }
}