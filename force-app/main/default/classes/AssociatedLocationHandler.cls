public with sharing class AssociatedLocationHandler extends TriggerHandler {

    public override void afterInsert(){
        this.criar((List<AssociatedLocation>) Trigger.new);
    }

    public override void afterUpdate(){
        this.atualizar((List<AssociatedLocation>) Trigger.new, (Map<Id, AssociatedLocation>) Trigger.oldMap);
    }

        public override void afterDelete(){
        this.excluir((List<AssociatedLocation>) Trigger.old);
    }

    //=======================================================================================================
    private void criar(List<AssociatedLocation> locais){

        Set<Id> idConta = new Set<Id>();
        Set<Id> idUsuario = new Set<Id>();

        for (AssociatedLocation local : locais){
            if (local.ParentRecordId != null && local.UserId__c != null){
                idConta.add(local.ParentRecordId);
                idUsuario.add(local.UserId__c);
            }
        }

        List<AccountTeamMember> contasExistentes = [SELECT AccountId, UserId FROM AccountTeamMember WHERE AccountId IN :idConta AND UserId IN :idUsuario];
        List<Id> contasExistentesIds = new List<Id>();
        List<Id> userIdContas = new List<Id>();

        for (AccountTeamMember conta : contasExistentes){
            contasExistentesIds.add(conta.AccountId);
            userIdContas.add(conta.UserId);
        }

        List<AccountTeamMember> contasParaAdicionar = new List<AccountTeamMember>();

        for (AssociatedLocation local : locais){
            Boolean jaExiste = false;

            for (AccountTeamMember conta : contasExistentes){

                if (conta.AccountId == local.ParentRecordId && conta.UserId == local.UserId__c){
                    System.debug('Conta já existe');
                    jaExiste = true;
                    break;
                }
        }

        if (!jaExiste){
            System.debug('Adicionando contas a lista de contas para inserir');
            contasParaAdicionar.add(new AccountTeamMember(
                            AccountId = local.ParentRecordId, 
                            UserId = local.UserId__c,
                            TeamMemberRole = 'Admnistrador',
                            AccountAccessLevel = 'All',
                            CaseAccessLevel = 'None',
                            OpportunityAccessLevel = 'None'));
            }
        }

        if (!contasParaAdicionar.isEmpty()){
            System.debug('Inserindo contas');
            System.debug('Total de contas para inserir: ' + contasParaAdicionar.size());
            insert contasParaAdicionar;
        }

    }

    //=======================================================================================================
    private void atualizar(List<AssociatedLocation> locaisNovos, Map<Id, AssociatedLocation> locaisAntigos){

        List<AssociatedLocation> locaisAtualizados = new List<AssociatedLocation>();
        Set<Id> idsContas = new Set<Id>();
        Set<Id> idsUsuarios = new Set<Id>();

        for (AssociatedLocation local : locaisNovos){
            
            AssociatedLocation antigo = locaisAntigos.get(local.Id);

            System.debug('idlocal: ' + local.Id);
            System.debug('Valor antigo: ' + antigo.UserId__c);
            System.debug('Valor novo: ' + local.UserId__c);

            if (local.UserId__c != antigo.UserId__c){
                locaisAtualizados.add(local);
                idsContas.add(local.ParentRecordId);
                idsUsuarios.add(local.UserId__c);
            }

            if (local.ParentRecordId != antigo.ParentRecordId){
                locaisAtualizados.add(local);
                idsContas.add(antigo.ParentRecordId);
                idsUsuarios.add(local.UserId__c);
            }
        }

        //ADICIONA NOVO USUARIO A ACCOUNT TEAM MEMBER
        System.debug('Adicionando novo usuario ao team member');
        
        if (!locaisAtualizados.isEmpty()){
            this.criar(locaisAtualizados);
            System.debug('Adicionando novo usuario ao team member2');
        }

        //QUEM AINDA TEM LOCAIS VINCULADOS A ACCOUNT TEAM MEMBER
        //Quem ainda tem locais vinculados a accountTeamMember
        List<AssociatedLocation> contaUsuarioAntigo = [SELECT ParentRecordId, UserId__c FROM AssociatedLocation WHERE ParentRecordId IN :idsContas AND UserId__c IN :idsUsuarios];

        Set<String> chaveContasExistentes = new Set<String>();
        
        for (AssociatedLocation conta : contaUsuarioAntigo){
            chaveContasExistentes.add(conta.ParentRecordId + ' ' + conta.UserId__c);
        }

        List<Id> idsContasParaRemover = new List<Id>();
        List<Id> idsUsuariosParaRemover = new List<Id>();

        for (AssociatedLocation local : locaisAtualizados){
        
            AssociatedLocation antigo = locaisAntigos.get(local.Id);
            
            String chaveTrocaRep = local.ParentRecordId + ' ' + local.UserId__c;

            if (local.UserId__c != antigo.UserId__c){
                if (!chaveContasExistentes.contains(chaveTrocaRep)){
                    idsContasParaRemover.add(local.ParentRecordId);
                    idsUsuariosParaRemover.add(antigo.UserId__c);
                }
            }


            String chaveContasAntigas = antigo.ParentRecordId + ' ' + local.UserId__c;

            if (local.ParentRecordId != antigo.ParentRecordId){
                if (!chaveContasExistentes.contains(chaveContasAntigas)){
                    idsContasParaRemover.add(antigo.ParentRecordId);
                    idsUsuariosParaRemover.add(local.UserId__c);
                }
            }
            
        }

        if (!idsContasParaRemover.isEmpty()){
            List<AccountTeamMember> contasParaRemover = [SELECT Id FROM AccountTeamMember WHERE AccountId IN :idsContasParaRemover AND UserId IN :idsUsuariosParaRemover];

            if (!contasParaRemover.isEmpty()){
                delete contasParaRemover;
            }
        }
    }

    //=======================================================================================================
    private void excluir(List<AssociatedLocation> locaisAntigos){
        Set<Id> idsContas = new Set<Id>();
        Set<Id> idsUsuarios = new Set<Id>();

        for (AssociatedLocation local : locaisAntigos){
            if (local.ParentRecordId != null && local.UserId__c != null){
                idsContas.add(local.ParentRecordId);
                idsUsuarios.add(local.UserId__c);
            }
        }

        if (idsContas.isEmpty()) return;

        List<AssociatedLocation> contaUsuarioAntigo = [SELECT ParentRecordId, UserId__c FROM AssociatedLocation WHERE ParentRecordId IN :idsContas AND UserId__c IN :idsUsuarios];

        Set<String> chaveContasExistentes = new Set<String>();
        for (AssociatedLocation la : contaUsuarioAntigo){
            chaveContasExistentes.add(la.ParentRecordId + ' ' + la.UserId__c);
        }

        List<Id> idsContasParaRemover = new List<Id>();
        List<Id> idsUsuariosParaRemover = new List<Id>();

        for (AssociatedLocation local : locaisAntigos){
            String chaveDeletada = local.ParentRecordId + ' ' + local.UserId__c;
        
            if (!chaveContasExistentes.contains(chaveDeletada)){
                idsContasParaRemover.add(local.ParentRecordId);
                idsUsuariosParaRemover.add(local.UserId__c);
            }
        }

        if (!idsContasParaRemover.isEmpty()){
            List<AccountTeamMember> contasParaRemover = [SELECT Id FROM AccountTeamMember WHERE AccountId IN :idsContasParaRemover AND UserId IN :idsUsuariosParaRemover];

            if (!contasParaRemover.isEmpty()){
                delete contasParaRemover;
            }
        }


    }
}
