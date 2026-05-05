public with sharing class OrderHandler extends TriggerHandler {
    
    public override void afterUpdate(){
        recalculatePrice((List<Order>) Trigger.new, (Map<Id, Order>) Trigger.oldMap);
    }

    public override void beforeUpdate(){
        validateChanges((List<Order>) Trigger.new, (Map<Id, Order>) Trigger.oldMap);
    }

    //APOS A ATUALIZACAO DE VALORES DE ENDERECO E CENTRO DE DISTRIBUICAO EM PEDIDO
    //CALCULA O PRECO DOS ITENS DO PEDIDO NOVAMENTE
    private void recalculatePrice(List<Order> newOrders, Map<Id, Order> oldOrders){

        Set<Id> updatedOrdersIds = new Set<Id>();
        
        //PERCORRE A LISTA DE NOVOS PEDIDOS, COMPARANDO OS PARAMETROS DO PEDIDO ANTIGO COM O ATUAL
        for (Order order : newOrders){

            Order oldOrder = oldOrders.get(order.Id);

            Boolean changedAddress = order.Address__c != oldOrder.Address__c;
            Boolean changedCenterDistribution = order.Distribution_Center__c != oldOrder.Distribution_Center__c;

            //SE ALGUM DOS PARAMETROS FOI ALTERADO, ADICIONA O PEDIDO NA LISTA DE IDS DE PEDIDOS QUE SERAO ATUALIZADOS
            if (changedAddress || changedCenterDistribution){
                updatedOrdersIds.add(order.Id);
            }
        }

        //FAZ UMA QUERY PARA BUSCAR OS ITENS DOS PEDIDOS QUE SERAO ATUALIZADOS
        if (!updatedOrdersIds.isEmpty()){
            List<OrderItem> itemsFound = [SELECT Id
                                            FROM OrderItem
                                            WHERE OrderId IN :updatedOrdersIds
            ];
        
            //ATUALIZA OS PEDIDOS COM O PRECO JA RECALCULADO
            if (!itemsFound.isEmpty()){     
                System.debug('Itens dos pedidos que serão atualizados: ' + itemsFound.size());
                
                try{
                    update itemsFound;
                }
                catch (DmlException error){
                    
                    for (Order order : newOrders){
                        if (updatedOrdersIds.contains(order.Id)){
                            order.addError('Erro ao atualizar o pedido e seus itens devido a falta de parâmetros, entre em contato com o time de pricing.');
                        }
                    }
                }
            }
        }
    }

    //VALIDACOES DE ALTERACAO DE PEDIDO
    private void validateChanges(List<Order> newOrders, Map<Id, Order> oldOrders){
        
        for (Order order : newOrders){
            Order oldOrder = oldOrders.get(order.Id);

            //VERIFICA SE A CONTA DO PEDIDO PODE SER ALTERADA
            if (order.AccountId != oldOrder.AccountId) order.addError('Não é possível atualizar a conta do pedido');
    
            //VALIDA SE O PEDIDO ESTA ATIVO, NAO DEIXA ALTERAR O PEDIDO SE JA ESTIVER ATIVO
            if (oldOrder.Status == 'Activated'){
                order.addError('Não é possível fazer qualquer alteração em um pedido que está Ativo');
            }
        }   
    }
}