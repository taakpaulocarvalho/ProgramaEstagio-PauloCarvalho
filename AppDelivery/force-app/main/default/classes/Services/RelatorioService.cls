public with sharing class RelatorioService {


    // GERA RELATORIO DE TOP 3 PRODUTOS MAIS VENDIDOS
    // RETORNA UM MAP DE CHAVE: PRODUTO E VALOR: QUANTIDADE
    public static Map<Produto, Integer> gerarRelatorioProdutosMaisVendidos(List<Pedido> pedidos){
        
        Map<Produto,Integer> ordenarProdutos = new Map<Produto,Integer>();    

        for (Pedido pedido : pedidos){

            if (pedido != null){
                for (ItemPedido item : pedido.getItens()){
                    if (item.produto == null) continue;

                    Integer quantidadeAtual = ordenarProdutos.containsKey(item.produto) ? ordenarProdutos.get(item.produto) : 0;
                    ordenarProdutos.put(item.produto, item.adicionarQuantidade(quantidadeAtual));
                }
            }
        }

        List<OrdenarProdutosService> produtosOrdenados = new List<OrdenarProdutosService>();
        for(Produto prod : ordenarProdutos.keySet()){
            produtosOrdenados.add(new OrdenarProdutosService(prod, ordenarProdutos.get(prod)));
        }

        produtosOrdenados.sort();

        System.debug('TOP 3 Produto mais vendidos:');
        for (Integer i = 0; i < 3; i++){
            System.debug(produtosordenados[i].produto.nome + ': ' + produtosordenados[i].quantidade + ' unidades');
        }

        return ordenarProdutos;
    }


    //RETORNA UM MAP DE CHAVE: CPF E VALOR: LISTA DE PEDIDOS POR CLIENTE
    public static Map<Documento, List<Pedido>> gerarRelatorioPedidosPorCliente(List<Pedido> pedidos, List<Documento> cpfs){

        Map<Documento,List<Pedido>> pedidosPorCliente = new Map<Documento,List<Pedido>>();
        Set<Documento> cpfSet = new Set<Documento>(cpfs);

        for (Pedido pedido : pedidos){
            if (pedido == null || pedido.cliente == null ) continue;
            
            Documento cpf = pedido.cliente.documento;
            
            if (cpfSet.contains(cpf)){
                
                pedidosPorCliente.put(cpf, pedidosPorCliente.get(cpf) != null ? pedidosPorCliente.get(cpf) : new List<Pedido>());
                pedidosPorCliente.get(cpf).add(pedido);
            }
        }

        for (Documento cpf : pedidosPorCliente.keySet()){
            System.debug('Cliente: ' + cpf + ' - ' + pedidosPorCliente.get(cpf).size() + ' pedidos');
        }

        return pedidosPorCliente;
    }
}