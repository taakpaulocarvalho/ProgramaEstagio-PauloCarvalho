public with sharing class MargemHandler extends TriggerHandler{
    
    public override void beforeInsert(){
        verificaDuplicidade((List<Margem__c>) Trigger.new);
    }
    
    public override void beforeUpdate(){
        verificaDuplicidade((List<Margem__c>) Trigger.new);
    }

    private void verificaDuplicidade(List<Margem__c> novasMargens){

        Set<String> chavesNovas = new Set<String>();
        Set<Id> idsProdutos = new Set<Id>();
        Set<Id> idsHierarquias = new Set<Id>();
        Set<Id> idsCentrosDistribuicao = new Set<Id>();
        Set<Id> idsContas = new Set<Id>();
        Set<Id> idsGruposConta = new Set<Id>();
        Set<Id> idsCidades = new Set<Id>();
        Set<Id> idsEstados = new Set<Id>();
        Set<Id> idsPaises = new Set<Id>();


        //VERIFICA SE EXISTEM CHAVES DUPLICADAS NA LISTA DE MARGENS QUE IRAO SER CADASTRADOS 
        for (Margem__c margem : novasMargens){

            String chave = gerarChave(margem);

            if (chavesNovas.contains(chave)){
                margem.addError('Não é permitido cadastrar margens duplicadas!');
            }
            chavesNovas.add(chave);

            if (margem.Produto__c != null) idsProdutos.add(margem.Produto__c);
            if (margem.Hierarquia_Produto__c != null) idsHierarquias.add(margem.Hierarquia_Produto__c);
            if (margem.Centro_Distribuicao__c != null) idsCentrosDistribuicao.add(margem.Centro_Distribuicao__c);
            if (margem.Conta__c != null) idsContas.add(margem.Conta__c);
            if (margem.Grupo_Conta__c != null) idsGruposConta.add(margem.Grupo_Conta__c);
            if (margem.Cidade__c != null) idsCidades.add(margem.Cidade__c);
            if (margem.Estado__c != null) idsEstados.add(margem.Estado__c);
            if (margem.Pais__c != null) idsPaises.add(margem.Pais__c);
        }

        //BUSCA DE MARGENS PRESENTES NO BANCO
        List<Margem__c> margensNoBanco = [SELECT Id, Produto__c, Hierarquia_Produto__c, Centro_Distribuicao__c, Conta__c, Grupo_Conta__c, Cidade__c, Estado__c, Pais__c 
                                            FROM Margem__c
                                            WHERE Id NOT IN :novasMargens
                                            AND (Produto__c IN :idsProdutos OR Produto__c = null) 
                                            AND (Hierarquia_Produto__c IN :idsHierarquias OR Hierarquia_Produto__c = null) 
                                            AND (Centro_Distribuicao__c IN :idsCentrosDistribuicao OR Centro_Distribuicao__c = null)
                                            AND (Conta__c IN :idsContas OR Conta__c = null)
                                            AND (Grupo_Conta__c IN :idsGruposConta OR Grupo_Conta__c = null)
                                            AND (Cidade__c IN :idsCidades OR Cidade__c = null)
                                            AND (Estado__c IN :idsEstados OR Estado__c = null)
                                            AND (Pais__c IN :idsPaises OR Pais__c = null)];

        //MAPEIA AS CHAVES DO BANCO       
        Set<String> chavesExistentesBanco = new Set<String>();
        for (Margem__c margemBanco : margensNoBanco){
            String chave = gerarChave(margemBanco);
            chavesExistentesBanco.add(chave);
        }

        //VERIFICA SE AS CHVAVES ATUAIS JA ESTAO NO BANCO
        for (Margem__c margem : novasMargens){
            if (chavesExistentesBanco.contains(gerarChave(margem))){
                margem.addError('Já existe uma Margem cadastrada para essa combinacao de Produto, Hierarquia, Centro de Distribuicao, Conta, Grupo de Conta, Cidade, Estado, Pais');
            }
        }
    }

    private String gerarChave(Margem__c margem){
        return '' + String.valueOf(margem.Produto__c) + 
                    String.valueOf(margem.Hierarquia_Produto__c) + 
                    String.valueOf(margem.Centro_Distribuicao__c) + 
                    String.valueOf(margem.Conta__c) +
                    String.valueOf(margem.Grupo_Conta__c) +
                    String.valueOf(margem.Cidade__c) +
                    String.valueOf(margem.Estado__c) +
                    String.valueof(margem.Pais__c);
    }
}