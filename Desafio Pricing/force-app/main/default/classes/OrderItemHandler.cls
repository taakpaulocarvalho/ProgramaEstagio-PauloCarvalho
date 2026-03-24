public with sharing class OrderItemHandler extends TriggerHandler{

    public override void beforeInsert(){
        aplicaImposto((List<OrderItem>) Trigger.new);
    }

    public override void beforeUpdate(){
        aplicaImposto((List<OrderItem>) Trigger.new);
    }

    private void aplicaImposto(List<OrderItem>  novosItens){

        Set<Id> idsPedidos = new Set<Id>();
        Set<Id> idsProdutos = new Set<Id>();

        //COLETAR IDS DOS PEDIDOS E PRODUTOS
        for(OrderItem item : novosItens){

            if (item.OrderId != null) idsPedidos.add(item.OrderId);
            if (item.Product2Id != null) idsProdutos.add(item.Product2Id);
        }

        //BUSCAR OS DADOS DO PEDIDO
        Map<Id, Order> pedidosMapa = new Map<id, Order>([
                SELECT Id, Centro_Distribuicao__c, Endereco__r.Cidade__r.Estado__c
                FROM Order
                WHERE Id IN :idsPedidos
        ]);

        Set<Id> idsCentrosDistribuicao = new Set<Id>();
        Set<Id> idsEstados = new Set<Id>();
        for (Order pedido : pedidosMapa.values()){
            if (pedido.Centro_Distribuicao__c != null) idsCentrosDistribuicao.add(pedido.Centro_Distribuicao__c);
            if (pedido.Endereco__r != null && pedido.Endereco__r.Cidade__r != null) idsEstados.add(pedido.Endereco__r.Cidade__r.Estado__c);
        }

        //BUSCA DE IMPOSTOS APROVADOS PRESENTES NO BANCO
        List<Imposto__c> impostosNoBanco = [SELECT Id, Produto__c, Centro_Distribuicao__c, Estado__c, Imposto_Sobre_Custo__c
                                            FROM Imposto__c
                                            WHERE Status__c = 'Aprovado'
                                            AND Produto__c IN :idsProdutos
                                            AND Centro_Distribuicao__c IN :idsCentrosDistribuicao
                                            AND Estado__c IN :idsEstados];


        System.debug('QUANTOS IMPOSTOS O SOQL ACHOU? ' + impostosNoBanco.size() );
       
       //MAPEIA IMPOSTOS ENCONTRADOS 
        Map<String, Decimal> mapaImpostoSobreCusto = new Map<String, Decimal>();
        for (Imposto__c imposto : impostosNoBanco){
            String chave = '' + imposto.Produto__c + imposto.Centro_Distribuicao__c + imposto.Estado__c;
            mapaImpostoSobreCusto.put(chave, imposto.Imposto_Sobre_Custo__c);
        }

        //APLICA IMPOSTO SOBRE PRODUTO DO PEDIDO
        for (OrderItem item : novosItens){
            Order pedido = pedidosMapa.get(item.OrderId);

            //PEGA O ESTADO NAVEGANDO PELO RELACIONAMENTO DO PEDIDO
            Id idEstado = (pedido != null && pedido.Endereco__r != null && pedido.Endereco__r.Cidade__r != null) ? pedido.Endereco__r.Cidade__r.Estado__c : null;

            //CHAVE PARA O ITEM ATUAL
            String chaveBusca = '' + item.Product2Id + pedido.Centro_Distribuicao__c + idEstado;
            
            //VERIFICA SE EXISTE IMPPOSTO PARA O ITEM ATUAL
            if (mapaImpostoSobreCusto.containsKey(chaveBusca)){
                item.Porcentagem_Imposto__c = mapaImpostoSobreCusto.get(chaveBusca);
                System.debug('IMPOSTO APLICADO');
            }
            else{
                item.addError('Não está autorizada a venda deste produto devido a falta de parâmetros de Imposto. Entre em contato com o time de pricing.');
            }
        }
    }
}