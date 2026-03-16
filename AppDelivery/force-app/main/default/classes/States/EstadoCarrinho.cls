public with sharing class EstadoCarrinho extends EstadoPedido{
    
    public override void adicionarProduto(Pedido pedido, Produto produto, Integer quantidade){
        System.debug('Adicionando Produto!');
    }
    
    public override void removerProduto(Pedido pedido, Produto produto){
        System.debug('Removendo Produto!');
    }

    public override void confirmar(Pedido pedido){
        
        System.debug('Confirmando Pedido e alterando estado para EM PROCESSAMENTO!');
        pedido.trocarEstado(new EstadoEmProcessamento());
    }

    public override void cancelar(Pedido pedido){

        System.debug('Cancelando Pedido e alterando estado para CANCELADO!');
        pedido.trocarEstado(new EstadoCancelado());
    }

    public override void marcarComoEntregue(Pedido pedido){
        throw new IllegalArgumentException('É necessário CONFIRMAR o pedido antes de finalizar a entrega!');
    }
}