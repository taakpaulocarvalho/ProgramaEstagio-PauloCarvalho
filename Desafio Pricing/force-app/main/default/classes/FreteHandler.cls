public with sharing class FreteHandler extends TriggerHandler {
    
    public override void beforeInsert(){
        verificaDuplicidade((List<Frete__c>) Trigger.new);
    }

    public override void beforeUpdate(){
        verificaDuplicidade((List<Frete__c>) Trigger.new);
    }

    private void verificaDuplicidade(List<Frete__c> novosFretes){

        Set<String> chavesNovas = new Set<String>();
        Set<Id> idsProdutos = new Set<Id>();
        Set<Id> idsHierarquias = new Set<Id>();
        Set<Id> idsCentrosDistribuicao = new Set<Id>();
        Set<Id> idsCidades = new Set<Id>();
        Set<Id> idsEstados = new Set<Id>();
        Set<Id> idsPaises = new Set<Id>();

        //VERIFICA SE EXISTEM CHAVES DUPLICADAS NA LISTA DE FRETES QUE IRAO SER CADASTRADOS  
        for (Frete__c frete : novosFretes){

            String chave = gerarChave(frete);

            if ((chavesNovas.contains(chave))){
                frete.addError('Não é permitido cadastrar fretes duplicados!');
            }
            chavesNovas.add(chave);

            if (frete.Produto__c != null) idsProdutos.add(frete.Produto__c);
            if (frete.Hierarquia_Produto__c != null) idsHierarquias.add(frete.Hierarquia_Produto__c);
            if (frete.Centro_Distribuicao__c != null) idsCentrosDistribuicao.add(frete.Centro_Distribuicao__c);
            if (frete.Cidade__c != null) idsCidades.add(frete.Cidade__c);
            if (frete.Estado__c != null) idsEstados.add(frete.Estado__c);
            if (frete.Pais__c != null) idsPaises.add(frete.Pais__c);

            if (frete.Id != null) idsFretesAtualizacao.add(frete.Id);
        }   


        //BUSCA DE FRETES PRESENTES NO BANCO
        List<Frete__c> fretesNoBanco = [SELECT Id, Produto__c, Hierarquia_Produto__c, Centro_Distribuicao__c, Cidade__c, Estado__c, Pais__c 
                                            FROM Frete__c
                                            WHERE Id NOT IN :novosFretes
                                            AND (Produto__c IN :idsProdutos OR Produto__c = null)
                                            AND (Hierarquia_Produto__c IN :idsHierarquias OR Hierarquia_Produto__c = null)
                                            AND (Centro_Distribuicao__c IN :idsCentrosDistribuicao OR Centro_Distribuicao__c = null)
                                            AND (Cidade__c IN :idsCidades OR Cidade__c = null)
                                            AND (Estado__c IN :idsEstados OR Estado__c = null)
                                            AND (Pais__c IN :idsPaises OR Pais__c = null)];

        
        //MAPEIA AS CHAVES DO BANCO                                               
        Set<String> chavesExistentesBanco = new Set<String>();
        for (Frete__c freteBanco : fretesNoBanco){
            String chave = gerarChave(freteBanco);
            chavesExistentesBanco.add(chave);
        }

        //VERIFICA SE AS CHVAVES ATUAIS JA ESTAO NO BANCO
        for (Frete__c frete : novosFretes){

            if(chavesExistentesBanco.contains(gerarChave(frete))){
                frete.addError('Já existe um frete cadastrado para essa combinação de Produto, Hierarquia, Centro de Distribuicao, Cidade, Estado, Pais.');
            }
        }
    }

    private String gerarChave(Frete__c frete){
        return '' + String.valueOf(frete.Produto__c) + 
                    String.valueOf(frete.Hierarquia_Produto__c) + 
                    String.valueOf(frete.Centro_Distribuicao__c) + 
                    String.valueOf(frete.Cidade__c) +
                    String.valueOf(frete.Estado__c) +
                    String.valueof(frete.Pais__c);
                    
    }
}