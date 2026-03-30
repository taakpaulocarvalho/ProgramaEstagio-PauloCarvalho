public with sharing class OrderHandler extends TriggerHandler {
    
    public override void afterUpdate(){
        recalculaPreco((List<Order>) Trigger.new, (Map<Id, Order>) Trigger.oldMap);
    }

    public override void beforeUpdate(){
        validaAlteracoes((List<Order>) Trigger.new, (Map<Id, Order>) Trigger.oldMap);
    }

    //APOS A ATUALIZACAO DE VALORES DE ENDERECO, CENTRO DE DISTRIBUICAO OU GRUPO DE CLIENTE EM PEDIDO
    //CALCULA O PRECO DOS ITENS DO PEDIDO NOVAMENTE
    private void recalculaPreco(List<Order> novosPedidos, Map<Id, Order> antigosPedidos){

        Set<Id> idsPedidosAtualizados = new Set<Id>();
        
        //PERCORRE A LISTA DE NOVOS PEDIDOS, COMPARANDO OS PARAMETROS DO PEDIDO ANTIGO COM O ATUAL
        for (Order pedido : novosPedidos){

            Order pedidoAntigo = antigosPedidos.get(pedido.Id);

            Boolean mudouEndereco = pedido.Endereco__c != pedidoAntigo.Endereco__c;
            Boolean mudouCentroDistribuicao = pedido.Centro_Distribuicao__c != pedidoAntigo.Centro_Distribuicao__c;
            Boolean mudouGrupoCliente = pedido.Account.Grupo_Clientes__c != pedidoAntigo.Account.Grupo_Clientes__c;

            //SE ALGUM DOS PARAMETROS FOI ALTERADO, ADICIONA O PEDIDO NA LISTA DE IDS DE PEDIDOS QUE SERAO ATUALIZADOS
            if (mudouEndereco || mudouCentroDistribuicao || mudouGrupoCliente){
                idsPedidosAtualizados.add(pedido.Id);
            }
        }

        //FAZ UMA QUERY PARA BUSCAR OS ITENS DOS PEDIDOS QUE SERAO ATUALIZADOS
        if (!idsPedidosAtualizados.isEmpty()){
            List<OrderItem> itensPedidos = [SELECT Id
                                            FROM OrderItem
                                            WHERE OrderId IN :idsPedidosAtualizados
            ];
        
            if (!itensPedidos.isEmpty()){

                List<OrderItem> itensPedidosAtualizados = [SELECT Id FROM OrderItem
                                                            WHERE OrderId IN :idsPedidosAtualizados
                ];                                           

                //ATUALIZA OS PEDIDOS COM O PRECO JA RECALCULADO
                if (!itensPedidosAtualizados.isEmpty()) update itensPedidosAtualizados;
            }
        }
    }

    //VALIDACOES DE ALTERACAO DE PEDIDO
    private void validaAlteracoes(List<Order> novosPedidos, Map<Id, Order> antigosPedidos){
        
        for (Order pedido : novosPedidos){
            Order pedidoAntigo = antigosPedidos.get(pedido.Id);

            //VERIFICA SE A CONTA DO PEDIDO PODE SER ALTERADA
            if (pedido.AccountId != pedidoAntigo.AccountId) pedido.addError('Não é possível atualizar a conta do pedido');
    
            //VALIDA SE O PEDIDO ESTA ATIVO, NAO DEIXA ALTERAR O PEDIDO SE JA ESTIVER ATIVO
            if (pedidoAntigo.Status == 'Activated'){
                pedido.addError('Não é possível fazer qualquer alteração em um pedido que está Ativo');
            }
        }   
    }
}