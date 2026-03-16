public with sharing class RelatorioService {

    public static Map<Produto, Integer> gerarRelatorioProdutosMaisVendidos(List<Pedido> pedidos){
        
        Map<Produto,Integer> ordenarProdutos = new Map<Produto,Integer>();    

        for (Pedido pedido : pedidos){

            if (pedido != null){
                for (ItemPedido item : pedido.itens){
                    if (item.produto == null) continue;

                    Integer quantidadeAtual = ordenarProdutos.get(item.produto) != null ? ordenarProdutos.get(item.produto) : 0;
                    ordenarProdutos.put(item.produto, item.quantidade + quantidadeAtual);
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


    public static Map<String, List<Pedido>> gerarRelatorioPedidosPorCliente(List<Pedido> pedidos, List<String> cpfs){

        Map<String,List<Pedido>> pedidosPorCliente = new Map<String,List<Pedido>>();
        Set<String> cpfSet = new Set<String>(cpfs);

        for (Pedido pedido : pedidos){
            if (pedido == null || pedido.cliente == null ) continue;
            
            String cpf = pedido.cliente.cpf;
            
            if (cpfSet.contains(cpf)){
                
                pedidosPorCliente.put(cpf, pedidosPorCliente.get(cpf) != null ? pedidosPorCliente.get(cpf) : new List<Pedido>());
                pedidosPorCliente.get(cpf).add(pedido);
            }
        }

        for (String cpf : pedidosPorCliente.keySet()){
            System.debug('Cliente: ' + cpf + ' - ' + pedidosPorCliente.get(cpf).size() + ' pedidos');
        }

        return pedidosPorCliente;
    }
}