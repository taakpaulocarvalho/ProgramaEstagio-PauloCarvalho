public with sharing class OrderHandler extends TriggerHandler {
    
    public override void afterUpdate(){
        recalculaPreco((List<Order>) Trigger.new, (Map<Id, Order>) Trigger.oldMap);
    }

    public override void beforeUpdate(){
        validaAlteracoes((List<Order>) Trigger.new, (Map<Id, Order>) Trigger.oldMap);
    }

    //APOS A ATUALIZACAO DE VALORES DE ENDERECO E CENTRO DE DISTRIBUICAO EM PEDIDO
    //CALCULA O PRECO DOS ITENS DO PEDIDO NOVAMENTE
    private void recalculaPreco(List<Order> novosPedidos, Map<Id, Order> antigosPedidos){

        Set<Id> idsPedidosAtualizados = new Set<Id>();
        
        //PERCORRE A LISTA DE NOVOS PEDIDOS, COMPARANDO OS PARAMETROS DO PEDIDO ANTIGO COM O ATUAL
        for (Order pedido : novosPedidos){

            Order pedidoAntigo = antigosPedidos.get(pedido.Id);

            Boolean mudouEndereco = pedido.Endereco__c != pedidoAntigo.Endereco__c;
            Boolean mudouCentroDistribuicao = pedido.Centro_Distribuicao__c != pedidoAntigo.Centro_Distribuicao__c;

            //SE ALGUM DOS PARAMETROS FOI ALTERADO, ADICIONA O PEDIDO NA LISTA DE IDS DE PEDIDOS QUE SERAO ATUALIZADOS
            if (mudouEndereco || mudouCentroDistribuicao){
                idsPedidosAtualizados.add(pedido.Id);
            }
        }

        //FAZ UMA QUERY PARA BUSCAR OS ITENS DOS PEDIDOS QUE SERAO ATUALIZADOS
        if (!idsPedidosAtualizados.isEmpty()){
            List<OrderItem> itensPedidos = [SELECT Id
                                            FROM OrderItem
                                            WHERE OrderId IN :idsPedidosAtualizados
            ];
        
            //ATUALIZA OS PEDIDOS COM O PRECO JA RECALCULADO
            if (!itensPedidos.isEmpty()){     
                System.debug('Itens dos pedidos que serão atualizados: ' + itenspedidos.size());
                
                try{
                    update itensPedidos;
                }
                catch (DmlException erro){
                    
                    for (Order pedido : novosPedidos){
                        if (idsPedidosAtualizados.contains(pedido.Id)){
                            pedido.addError('Erro ao atualizar o pedido e seus itens devido a falta de parâmetros, entre em contato com o time de pricing.');
                        }
                    }
                }
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