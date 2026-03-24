public with sharing class ImpostoHandler extends TriggerHandler{
    
    public override void beforeInsert(){
        verificaDuplicidade((List<Imposto__c>) Trigger.new);
    }

    public override void beforeUpdate(){
        verificaDuplicidade((List<Imposto__c>) Trigger.new);
    }

    private void verificaDuplicidade(List<Imposto__c> novosImpostos){

        Set<String> chavesNovas = new Set<String>();
        Set<Id> idsProdutos = new Set<Id>();
        Set<Id> idsCentrosDistribuicao = new Set<Id>();
        Set<Id> idsEstados = new Set<Id>();

        //VERIFICA SE EXISTEM CHAVES DUPLICADAS NA LISTA DE IMPOSTOS QUE IRAO SER CADASTRADOS  
        for (Imposto__c imposto : novosImpostos){

            String chave = gerarChave(imposto);

            if (chavesNovas.contains(chave)){
                imposto.addError('Não é permitido cadastrar impostos duplicados!');
            }
            chavesNovas.add(chave);


            if (imposto.Produto__c != null) idsProdutos.add(imposto.Produto__c);
            if (imposto.Centro_Distribuicao__c != null) idsCentrosDistribuicao.add(imposto.Centro_Distribuicao__c);
            if (imposto.Estado__c != null) idsEstados.add(imposto.Estado__c);
        }

        //BUSCA DE IMPOSTOS PRESENTES NO BANCO
        List<Imposto__c> impostosNoBanco = [SELECT Id, Produto__c, Centro_Distribuicao__c, Estado__c 
                                               FROM Imposto__c
                                               WHERE Id NOT IN :novosImpostos
                                               AND (Produto__c IN :idsProdutos)
                                               AND (Centro_Distribuicao__c IN :idsCentrosDistribuicao)
                                               AND (Estado__c IN :idsEstados)];


        //MAPEIA AS CHAVES DO BANCO                                               
        Set<String> chavesExistentesBanco = new Set<String>();
        for (Imposto__c impostoBanco : impostosNoBanco){
            String chave = gerarChave(impostoBanco);
            chavesExistentesBanco.add(chave);
        }

        //VERIFICA SE AS CHVAVES ATUAIS JA ESTAO NO BANCO
        for (Imposto__c imposto : novosImpostos){

            String chave = gerarChave(imposto);
            if (chavesExistentesBanco.contains(chave)){
                imposto.addError('Já existe um imposto cadastrado para essa combinação de Produto, Centro de Distribuição e Estado');
            }
        }
    }

    private String gerarChave(Imposto__c imposto){
        return '' + imposto.Produto__c + imposto.Centro_Distribuicao__c + imposto.Estado__c;
    }

}