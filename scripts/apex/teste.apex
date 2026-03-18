System.debug(' ');
System.debug(' ');
System.debug(' ');

System.debug('------ TESTE DO PROJETO ------');
Documento documento = new Documento('333.444.555-66');
Endereco endereco = new Endereco('Rua Aveiro', '10', 'Mansao', 'Santos');
Cliente cliente = new Cliente('Neymar Junior', documento, endereco, '11 92112 1212');

Endereco enderecoRestaurante = new Endereco('Faria Lima', '250', 'Casa', 'São Paulo');
Restaurante restaurante = new Restaurante('Pizzaria', enderecoRestaurante, CategoriaRestaurante.PIZZARIA, new List<Produto>());
Produto calabresa = new Produto('Pizza Calabresa', new Dinheiro(50.0), new PoliticaPrecoPadrao());
Produto mussarela = new Produto('Pizza Mussarela', new Dinheiro(45.0), new PoliticaPrecoPadrao());

System.debug(' ');
System.debug(' ');
System.debug(' ');

restaurante.adicionarProduto(calabresa);
restaurante.adicionarProduto(mussarela);

ProcessadorPedido processador = new ProcessadorPedido();
Pedido pedido = new Pedido(cliente, restaurante);

System.debug(' ');
System.debug('Estado inicial: ' + pedido.getNomeEstado());
System.debug(' ');

processador.adicionarProduto(pedido, calabresa, 1);
processador.adicionarProduto(pedido, mussarela, 1);
System.debug(' ');

System.debug('Total do pedido sem frete: ' + pedido.total.valorMonetario);
System.debug(' ');

processador.aplicarPoliticaFrete(pedido, new PoliticaDeFreteFixo(new Dinheiro(10.0)));

System.debug('Total do pedido com frete: ' + pedido.total.valorMonetario);
pedido.exibirResumo();
System.debug(' ');

processador.confirmarPedido(pedido);
pedido.exibirResumo();
System.debug('Novo estado: ' + pedido.getNomeEstado());
System.debug(' ');

try{
    processador.adicionarProduto(pedido, mussarela, 2);
} catch(Exception e){
    System.debug('BLOQUEADO!');
    System.debug('Erro: ' + e.getMessage());
}

System.debug(' ');
System.debug('DE PROCESSAMENTO PARA ENTREGUE!');
processador.finalizarPedido(pedido);
System.debug('Estado final: ' + pedido.getNomeEstado());
System.debug(' ');
pedido.exibirResumo();


System.debug(' ');
System.debug('Teste final de erros (CANCELAR PEDIDO ENTREGUE):');

try {
    processador.cancelarPedido(pedido);
    System.debug('ERRO!');
} catch (Exception E) {
    System.debug('BLOQUEADO!');
    System.debug('Erro: ' + e.getMessage());
}

