public with sharing class EstadoEntregue extends EstadoPedido{
    
    public override void adicionarProduto(Pedido pedido, Produto produto, Integer quantidade){
        throw new IllegalArgumentException('Não é possível adicionar produtos que está no estado de ENTREGUE!');
    }

    public override void removerProduto(Pedido pedido, Produto produto){
        throw new IllegalArgumentException('Não é possível remover produtos que está no estado de ENTREGUE!');
    }

    public override void confirmar(Pedido pedido){
        throw new IllegalArgumentException('O pedido já foi confirmado e ENTREGUE!');
    }

    public override void cancelar(Pedido pedido){
        throw new IllegalArgumentException('Não é possível cancelar um pedido que já foi ENTREGUE!');
    }

    public override void marcarComoEntregue(Pedido pedido){
        throw new IllegalArgumentException('O pedido já foi ENTREGUE!');
    }
}