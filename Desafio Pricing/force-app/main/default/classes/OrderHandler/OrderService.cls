public with sharing class OrderService {
   
    @future(callout=true)
    public static void getOrderResponseError(List<String> orderIdList){

        DataIntegrationFields.CalloutResponse response = CalloutOrder.executeCalloutOrder(orderIdList);

        List<Order> orderList = [SELECT Id FROM Order
                                WHERE Id IN :orderIdList];
        
        for (Order iOrder : orderList){

            if (response.hasError){
                iOrder.Status = 'Integration Error';
            }
            else{
                iOrder.Status = 'Integrated';
            }
        }
        update orderList;
    }

    @InvocableMethod(label='Remake Integration' description='Refazer callout de pedidos que falharam')
    public static void remakeIntegration(List<String> orderIdList){

        if (orderIdList != null && !orderIdList.isEmpty()) getOrderResponseError(orderIdList);
    }
    
}