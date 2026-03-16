public with sharing class EstadoEmProcessamento extends EstadoPedido{
    
    public override void adicionarProduto(Pedido pedido, Produto produto, Integer quantidade){
        throw new IllegalArgumentException('Não é possivel adicionar produtos em um item em PROCESSAMENTO!');
    }
    
    public override void removerProduto(Pedido pedido, Produto produto){
        throw new IllegalArgumentException('Não é possivel remover produtos em um item em PROCESSAMENTO!');
    }

    public override void confirmar(Pedido pedido){
        throw new IllegalArgumentException('Pedido já foi confirmado!');
    }

    public override void cancelar(Pedido pedido){
        System.debug('Cancelando Pedido e alterando estado para CANCELADO!');
        pedido.trocarEstado(new EstadoCancelado());
    }

    public override void marcarComoEntregue(Pedido pedido){
        System.debug('Pedido finalizado e marcando Pedido como ENTREGUE!');
        pedido.trocarEstado(new EstadoEntregue());
    }
}