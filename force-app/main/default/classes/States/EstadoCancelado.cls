public with sharing class EstadoCancelado extends EstadoPedido {

    public override void adicionarProduto(Pedido pedido, Produto produto, Integer quantidade){
        throw new IllegalArgumentException('Não é possível adicionar produtos, o pedido já foi CANCELADO!');
    }

    public override void removerProduto(Pedido pedido, Produto produto){
        throw new IllegalArgumentException('Não é possível remover produtos, o pedido já foi CANCELADO!');
    }

    public override void confirmar(Pedido pedido){
        throw new IllegalArgumentException('Não é possível confirmar um pedido que já foi CANCELADO!');
    }

    public override void cancelar(Pedido pedido){
        throw new IllegalArgumentException('O pedido já está CANCELADO!');
    }

    public override void marcarComoEntregue(Pedido pedido){
        throw new IllegalArgumentException('Não é possível marcar como entregue o pedido, pois ele já foi CANCELADO!');
    }
}