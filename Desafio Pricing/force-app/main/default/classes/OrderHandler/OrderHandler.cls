public with sharing class OrderHandler extends TriggerHandler {
    
    public override void afterUpdate(){
        recalculatePrice((List<Order>) Trigger.new, (Map<Id, Order>) Trigger.oldMap);
    }

    public override void beforeUpdate(){
        validateChanges((List<Order>) Trigger.new, (Map<Id, Order>) Trigger.oldMap);
        validateIntegration((List<Order>) Trigger.new, (Map<Id, Order>) Trigger.oldMap); 
        
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
        
        List<OrderItem> items = [SELECT Id FROM OrderItem WHERE OrderId IN :newOrders LIMIT 1];

        for (Order order : newOrders){
            Order oldOrder = oldOrders.get(order.Id);

            //VERIFICA SE A CONTA DO PEDIDO PODE SER ALTERADA
            if (order.AccountId != oldOrder.AccountId) order.addError('Não é possível atualizar a conta do pedido');
    
            //VALIDA SE O PEDIDO ESTA ATIVO, NAO DEIXA ALTERAR O PEDIDO SE JA ESTIVER ATIVO
            if (oldOrder.Status == 'Activated'){
                order.addError('Não é possível fazer qualquer alteração em um pedido que está Ativo');
            }

            // if (items.isEmpty() && order.Status != 'New'){
            //     order.addError('Não é possível alterar o status do pedido se ele não possuir itens');
            // }

            if ((oldOrder.Status == 'New' && order.Status == 'Approved')){
                order.addError('Não é permitido atualizar o status para Approval, antes de ser aprovado internamente.');
            }

            if (oldOrder.Status == 'Integrated'){
                order.addError('Não é possível fazer qualquer alteração em um pedido que está Integrado');
            }

            if ((oldOrder.Status == 'New' && order.Status == 'Integration Error') ||
                (oldOrder.Status == 'New' && order.Status == 'Integrated')){

                order.addError('Só é permitido o usuário atualizar o status do pedido de New para In Approval, o restante do processo de aprovação é interno.');
            }

            if (oldOrder.Status == 'Approved' && order.Status == 'New'){
                order.addError('Não é permitido atualizar o status de um pedido de Approved para New');
            }
        } 
    }

    private void validateIntegration(List<Order> newOrders, Map<Id, Order> oldOrders){

        List<String> orderIdList = new List<String>();
        for (Order order : newOrders){
            if (order.Status == 'Approved') orderIdList.add(order.Id);
        }

        if (!orderIdList.isEmpty()) {
            OrderService.getOrderResponseError(orderIdList);
        }
    }
}