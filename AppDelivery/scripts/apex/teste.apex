
//TESTES ETAPA 1
System.debug('TESTES ETAPA 1');
System.debug(' ');
Cliente cliente = new Cliente('Neymar', '4232445-54', 'SBC-SP', '(11)123123123');
Cliente cliente2 = new Cliente('Ana', '123.456.789-00', 'Rua Central, 123', '(11) 99999-8888');
Cliente cliente3 = new Cliente('Carlos', '987.654.321-00', 'Rua das Flores, 45', '(11) 98888-7777');



System.debug(cliente.nome + ' ' + cliente.cpf + ' ' + cliente.endereco + ' ' + cliente.telefone);

Produto p1 = new Produto('Pizza Mussarela', 35.0);
Produto p2 = new Produto('Pizza Calabresa', 38.0);
Produto p3 = new Produto('Pizza Calabresa', 38.0);
Produto p4 = new Produto('Refrigerante', 8.0);
Produto p5 = new Produto('Pastel', 6.50);
List<Produto> prod = new List<Produto>();
prod.add(p1);
prod.add(p2);
prod.add(p3);
prod.add(p4);
prod.add(p1);
prod.add(p5);
Restaurante restaurante = new Restaurante('Bella Pizza', 'Av Antartico 381', CategoriaRestaurante.PIZZARIA, null);

//System.debug(restaurante.nome + ' ' + restaurante.endereco + ' ' + restaurante.categoria + ' ' + restaurante.cardapio[0].nome + ' ' + restaurante.cardapio[0].preco);

System.debug(' ');
System.debug(' ');

//TESTES ETAPA 2 
System.debug('TESTES ETAPA 2 ');
restaurante.adicionarProduto(p1);
restaurante.adicionarProduto(p2);
restaurante.adicionarProduto(p3);
restaurante.adicionarProduto(p4);
restaurante.adicionarProduto(p5);
System.debug(' ');
System.debug('EXIBIR CARDAPIO');
restaurante.exibirCardapio();
System.debug(' ');
System.debug('BUSCAR PRODUTOS');
List<Produto> buscaProd = restaurante.buscarProdutos('Pizza');
for (Produto prod : buscaProd){
    System.debug('Produtos encontrados: ' + prod.nome + ' - ' + prod.preco);
}

System.debug('');
System.debug('');



System.debug('TESTES ETAPA 3');

Pedido pedido = new Pedido(cliente, restaurante);
System.debug('MÉTODO ADICIONAR PEDIDO');
System.debug('');
pedido.adicionarItemPedido(p1, 2);
pedido.adicionarItemPedido(p2, 1);
pedido.adicionarItemPedido(p2, 1);
pedido.adicionarItemPedido(p4, 1);
pedido.adicionarItemPedido(p5, 1);
System.debug('MÉTODO CALCULAR TOTAL');
System.debug('');
pedido.calcularTotal();
System.debug('MÉTODO CONFIRMAR PEDIDO');
System.debug('');
pedido.confirmarPedido();
System.debug('MÉTODO EXIBIR RESUMO');
System.debug('');
pedido.exibirResumo();



System.debug('');
System.debug('');
List<Pedido> pedidos = new List<Pedido>();

Pedido ped1 = new Pedido(cliente, restaurante);
Pedido ped2 = new Pedido(cliente2, restaurante);
Pedido ped3 = new Pedido(cliente3, restaurante);
Pedido ped4 = new Pedido(cliente, restaurante);


ped1.itens.add(new ItemPedido(p1, 2));
ped1.itens.add(new ItemPedido(p2, 2));
ped1.itens.add(new ItemPedido(p4, 2));
ped1.itens.add(new ItemPedido(p5, 5));

pedidos.add(ped1);
pedidos.add(ped2);
pedidos.add(ped3);
pedidos.add(ped4);

System.debug('TESTES ETAPA 4');


Pedido p1Etapa4 = new Pedido(cliente2, restaurante);
Pedido p2Etapa4 = new Pedido(cliente3, restaurante);
p1Etapa4.adicionarItemPedido(p1, 2);
p2Etapa4.adicionarItemPedido(p2, 2);

List<Pedido> pedidosEtapa4 = new List<Pedido>();
pedidosEtapa4.add(p1Etapa4);
pedidosEtapa4.add(p2Etapa4);

System.debug(' ');
System.debug('RELATORIO TOP 3:');
Map<Produto, Integer> ordenados = RelatorioService.gerarRelatorioProdutosMaisVendidos(pedidos);

System.debug(' ');
System.debug('MAPA RETORNADO');
for (Produto prod : ordenados.keySet()){
    System.debug('Produto: ' + prod.nome + ' - Quantidade: ' + ordenados.get(prod));
}

System.debug(' ');
System.debug('MAPA RETORNADO CLIENTES - CPF');
List<String> CPFList = new List<String>{};

CPFList.add(Cliente.cpf);
CPFList.add(cliente2.cpf);`
CPFList.add(cliente3.cpf);
Map<String, List<Pedido>> clientes = RelatorioService.gerarRelatorioPedidosPorCliente(pedidos, CPFList);

