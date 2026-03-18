public with sharing class ProcessadorPedido {
    
    public ProcessadorPedido(){}

    // ADICIONA PRODUTO AO PEDIDO
    public void adicionarProduto(Pedido pedido, Produto produto, Integer quantidade){
        
        if (!pedido.restaurante.getCardapio().contains(produto)) 
            throw new IllegalArgumentException('Produto ' + produto.nome + ' não existe no cardápio!');

        pedido.adicionarItemPedido(produto, quantidade);
    }


    //CONFIRMA O PEDIDO
    public void confirmarPedido(Pedido pedido){

        if (pedido == null || pedido.getItens().isEmpty()) 
            throw new IllegalArgumentException('O pedido deve ter pelo menos um item!');

        if (pedido.total.valorMonetario <= 0) 
            throw new IllegalArgumentException('O pedido deve ter um valor maior que zero!');

        for (ItemPedido item : pedido.getItens()){
            if (item.quantidade <= 0){
                throw new IllegalArgumentException('A quantidade do produto ' + item.produto.nome + ' deve ser maior que zero!');
            }
        }

        if (pedido.restaurante == null) throw new IllegalArgumentException('O pedido deve ter um restaurante!');
        
        pedido.confirmar();
        pedido.calcularTotal();
        System.debug('Pedido confirmado com sucesso!');
    }

    // FINALIZA PEDIDO
    public void finalizarPedido(Pedido pedido){

        pedido.finalizarEntrega();
        System.debug('Pedido entregue com sucesso!');
    }

    // CANCELA PEDIDO
    public void cancelarPedido(Pedido pedido){

        pedido.cancelar();
        System.debug('Pedido cancelado com sucesso!');
    }

    // REMOVE PRODUTO
    public void removerProduto(Pedido pedido, Produto produto){

        pedido.executarRemocao(produto);
    }

    // ALTERA QUANTIDADE DO PRODUTO PEDIDO
    public void alterarQuantidade(Pedido pedido, Produto produto, Integer quantidade){

        if (quantidade <= 0){
            pedido.executarRemocao(produto);
            return;
        }
        pedido.executaAlteraQuantidade(produto, quantidade);
        pedido.calcularTotal();
    }

    // APLICA POLITICA DE FRETE DE ACORDO COM O PARAMETRO PASSADO
    public void aplicarPoliticaFrete(Pedido pedido, PoliticaDeFrete politicaFrete){

        pedido.calcularTotal();
        pedido.aplicarFrete(politicaFrete.calcularFrete(pedido));
        pedido.calcularTotal();
        System.debug('Frete com valor de: ' + pedido.frete + ' aplicado de acordo com politica de frete!');
    }
}