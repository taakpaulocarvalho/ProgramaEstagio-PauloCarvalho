
/*
System.debug(' ');
System.debug(' ');
System.debug('PARTE 2 (AVANCADO):');
Documento doc1 = new Documento('12345678901');
Documento doc2 = new Documento('45847548341');
System.debug(' ');
System.debug('Documentos iguais? '  + doc1.equals(doc2));
System.debug('HashCode Documento 1: ' + doc1.hashCode());
System.debug('HashCode Documento 2: ' + doc2.hashCode());

System.debug(' ');
System.debug('TESTANDO ENDERECO');
Endereco end1 = new Endereco('Rua 1', '123', 'Casa', 'Sao Paulo');
Endereco end2 = new Endereco('Rua Azul', '13', 'APTO', 'SBC');

System.debug('Enderecos iguais? ' + end1.equals(end2));
System.debug('HashCode Endereco 1: ' + end1.hashCode());
System.debug('HashCode Endereco 2: ' + end2.hashCode());
System.debug(' ');
try{
    Dinheiro d1 = new Dinheiro(50.0);
    Dinheiro d2 = new Dinheiro(40.0);
    Dinheiro soma = d1.Somar(d2);
    System.debug(' ');
    System.debug('Resultado soma: ' + soma);

    System.debug(' ');
    System.debug('Valor de d1 ' + (d1.valorMonetario == 50.0));

    System.debug(' ');
    Dinheiro multiplicacao = d1.Multiplicar(2);
    System.debug('Resultado multiplicacao (50.0 * 2): ' + multiplicacao);

    System.debug(' ');
    System.debug('Os objetos d1 e d2 são iguais: ' + d1.equals(d2));
    System.debug('HashCode d1: ' + d1.hashCode());
    System.debug('HashCode d2: ' + d2.hashCode());

    System.debug(' ');
    Dinheiro negativo = new Dinheiro(-10.0);


}
catch(IllegalArgumentException e){
    System.debug('Erro: ' + e.getMessage());
}

System.debug(' ');
System.debug(' ');
System.debug('PARTE 3 (AVANCADO):');
Cliente c1 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');
Cliente c2 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');
System.debug('Verificar Cliente: ' + c1.nome + ' ' + c1.documento + ' ' + c1.endereco.cidade + ' ' + c1.telefone + ' ' + c1.getTipoPessoa());
System.debug(' ');
System.debug('Clientes iguais? ' + c1.equals(c2));
System.debug('HashCode Cliente 1: ' + c1.hashCode());
System.debug('HashCode Cliente 2: ' + c2.hashCode());
System.debug(' ');

try{
    Cliente clienteErrado = new Cliente('', doc1, end1, '(11)3943 2292');
}
catch(IllegalArgumentException e){
    System.debug('Erro: ' + e.getMessage());
}


System.debug(' ');
Dinheiro d1 = new Dinheiro(50.0);

Produto p1 = new Produto('Pizza Calabresa', d1);
Produto p2 = new Produto('Pizza Mussarela', d1);
List<Produto> cardapio = new List<Produto>();
cardapio.add(p1);
cardapio.add(p2);

CategoriaRestaurante cat = CategoriaRestaurante.PIZZARIA;
Restaurante rest1 = new Restaurante('Bella Pizza', end1, cat, cardapio);
Restaurante rest2 = new Restaurante('Bella Pizza', end1, cat, cardapio);

System.debug(' ');
System.debug('Restaurantes são iguais' + rest1.equals(rest2));
System.debug('HashCode Restaurante 1: ' + rest1.hashCode());
System.debug('HashCode Restaurante 2: ' + rest2.hashCode());

Pedido ped1 = new Pedido(c1, rest1);
ped1.adicionarItemPedido(p1, 2);

System.debug(' ');
System.debug('Valor do pedido: ' + ped1.total.valorMonetario);
*/
/*
System.debug('');
System.debug('ETAPA 2 - PARTE 1:');
System.debug(' ');

Documento doc1 = new Documento('12345678901');
Documento doc2 = new Documento('45847548341');

Endereco end1 = new Endereco('Rua 1', '123', 'Casa', 'Sao Paulo');
Endereco end2 = new Endereco('Rua Azul', '13', 'APTO', 'SBC');

Cliente c1 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');
Cliente c2 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');

CategoriaRestaurante cat = CategoriaRestaurante.PIZZARIA;

Dinheiro dinheiro1 = new Dinheiro(50.0);

Produto pizza1 = new Produto('Pizza Calabresa', dinheiro1);
Produto pizza2 = new Produto('Pizza Mussarela', dinheiro1);

List<Produto> cardapio = new List<Produto>();
cardapio.add(pizza1);
cardapio.add(pizza2);

System.debug('Produto: ' + pizza1.nome + ' - ' + pizza1.preco.valorMonetario);

Restaurante rest1 = new Restaurante('Bella Pizza', end1, cat, cardapio);

try{
    Pedido pedido = new Pedido(c1, rest1);
    System.debug('Pedido criado. Status: ' + pedido.status);

    pedido.adicionarItemPedido(pizza1, 2);
    System.debug('Valor do pedido: ' + pedido.total.valorMonetario);

    //ItemPedido item = new ItemPedido();
}
catch(IllegalArgumentException e){
    System.debug('Erro: ' + e.getMessage());
}


System.debug('');
System.debug('ETAPA 2 - PARTE 2:');
System.debug(' ');

try {
    Pedido pedido = new Pedido(c1, rest1);
    pedido.adicionarItemPedido(pizza1, 3);

    System.debug('Valor do pedido total: ' + pedido.total.valorMonetario);

    Produto produtoNegativo = new Produto('Produto Negativo', new Dinheiro(-10.0));
    pedido.adicionarItemPedido(produtoNegativo, 1);


} catch (IllegalArgumentException e) {
    System.debug('Erro: ' + e.getMessage());
}

try{
    Pedido pedido = new Pedido(c1, rest1);
    System.debug('Adicionando quantidade 0');
    pedido.adicionarItemPedido(pizza1, 0);

} catch (IllegalArgumentException e){
    System.debug('Erro: ' + e.getMessage());
}




System.debug('');
System.debug('ETAPA 2 - PARTE 3:');
System.debug(' ');

try{
    Pedido pedido = new Pedido(c1, rest1);

    pedido.adicionarItemPedido(pizza1, 2);
    pedido.alterarQuantidade(pizza1, 5);

    pedido.adicionarItemPedido(pizza2, 1);
    pedido.alterarQuantidade(pizza2, 0);

    pedido.removerProduto(pizza1);

    System.debug('Status: ' + pedido.status);
    System.debug('Valor do pedido total: ' + pedido.total.valorMonetario);

} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}


System.debug('');
System.debug('ETAPA 2 - PARTE 4:');
System.debug(' ');

try{
    Pedido pedido = new Pedido(c1, rest1);
    System.debug('Status inicial: ' + pedido.status);

    pedido.adicionarItemPedido(pizza1, 1);
    pedido.confirmarPedido();
    System.debug('Status apos confirmar: ' + pedido.status);


    pedido.removerProduto(pizza1);
    pedido.adicionarItemPedido(pizza2, 1);

} catch (Exception  e){
    System.debug('Erro: ' + e.getMessage());
}

try {
    Pedido pedido = new Pedido(c1, rest1);
    pedido.confirmarPedido();   

} catch (Exception e) {
    System.debug('Erro: ' + e.getMessage());
}



System.debug('');
System.debug('ETAPA 2 - PARTE 5:');
System.debug(' ');
*/
/*
Documento doc1 = new Documento('12345678901');
Documento doc2 = new Documento('45847548341');

Endereco end1 = new Endereco('Rua 1', '123', 'Casa', 'Sao Paulo');
Endereco end2 = new Endereco('Rua Azul', '13', 'APTO', 'SBC');

Cliente c1 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');
Cliente c2 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');

CategoriaRestaurante cat = CategoriaRestaurante.PIZZARIA;

Dinheiro dinheiro1 = new Dinheiro(50.0);

Produto pizza1 = new Produto('Pizza Calabresa', dinheiro1, new PoliticaPrecoPadrao());
Produto pizza2 = new Produto('Pizza Mussarela', dinheiro1, new PoliticaPrecoPadrao());

List<Produto> cardapio = new List<Produto>();
cardapio.add(pizza1);
cardapio.add(pizza2);

System.debug('');
System.debug('ETAPA 3 - PARTE 1:');
System.debug(' Apenas criacao da Interface');
System.debug('');


System.debug('ETAPA 3 - PARTE 2:');
System.debug('Ainda nenhuma classe implementa a interface para testar');
System.debug('');


System.debug('ETAPA 3 - PARTE 3:');
System.debug('');

try{
    Produto prod1 = new Produto('Pizza Calabresa', dinheiro1, new PoliticaPrecoPadrao());
    System.debug('Preco padrao: ' + prod1.calcularPrecoFinal().valorMonetario);

    Produto prod2 = new Produto('Pizza Calabresa', dinheiro1, new PoliticaPrecoComDescontoPercentual(10.0));
    System.debug('Preco com desconto: ' + prod2.calcularPrecoFinal().valorMonetario);

    Time inicio = Time.newInstance(18, 0, 0, 0);
    Time fim = Time.newInstance(22, 0, 0, 0);
    Time horaAtual = Time.newInstance(20, 0, 0, 0);

    Produto prod3 = new Produto('Pizza Calabresa', dinheiro1, new PoliticaPrecoPromocionalPorHorario(inicio, fim, horaAtual, 50.0));
    System.debug('Preco com desconto percentual: ' + prod3.calcularPrecoFinal().valorMonetario);

    
}
catch(Exception e){
    System.debug('Erro: ' + e.getMessage());
}

System.debug('ETAPA 3 - PARTE 4:');
System.debug('');


PoliticaDePreco politPreco = new PoliticaPrecoComDescontoPercentual(50);
ItemPedido pedido = ItemPedido.criarItemPedido(pizza1, 1);

System.debug('Subtotal: ' + pedido.calcularSubtotal().valorMonetario);
*/

/*
System.debug('');
System.debug('ETAPA 3 - PARTE 5:');
System.debug('');

Documento doc1 = new Documento('12345678901');
Documento doc2 = new Documento('45847548341');

Endereco end1 = new Endereco('Rua 1', '123', 'Casa', 'Sao Paulo');
Endereco end2 = new Endereco('Rua Azul', '13', 'APTO', 'SBC');

Cliente c1 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');
Cliente c2 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');

CategoriaRestaurante cat = CategoriaRestaurante.PIZZARIA;

Dinheiro dinheiro1 = new Dinheiro(50.0);

List<Produto> cardapio = new List<Produto>();


Time inicio = Time.newInstance(18, 0, 0, 0);
Time fim = Time.newInstance(22, 0, 0, 0);
Time horaAtual = Time.newInstance(20, 0, 0, 0);
Restaurante rest1 = new Restaurante('Bella Pizza', end1, cat, cardapio);

System.debug('Requisitos 1, 2, 3, e 4 (mesmo produto com diferentes politicas e altecao de politica em execucao):');
System.debug('Produto com politica padrão:');
Produto produtoPoliticas = new Produto('Pizza Calabresa', dinheiro1, new PoliticaPrecoPadrao());
System.debug('Preço padrão: ' + produtoPoliticas.calcularPrecoFinal().valorMonetario);
System.debug('');

System.debug('Produto com politica desconto percentual:');
produtoPoliticas.alterarPoliticaDePreco(new PoliticaPrecoComDescontoPercentual(50));
System.debug('Preço com desconto: ' + produtoPoliticas.calcularPrecoFinal().valorMonetario);
System.debug('');

System.debug('Produto com politica promocional:');
produtoPoliticas.alterarPoliticaDePreco(new PoliticaPrecoPromocionalPorHorario(inicio, fim, horaAtual, 50.0)); 
System.debug('Preço promocional por horario: ' + produtoPoliticas.calcularPrecoFinal().valorMonetario);
System.debug('');

System.debug('Requisito 5 (pedido com multiplos produtos com politicas diferentes):');
System.debug('Adicionando pedido com Politica de Preco Padrao, e outro com Politca com Desconto Percentual: ');

Produto prod1 = new Produto('Pizza Calabresa', dinheiro1, new PoliticaPrecoPadrao());
Produto prod2 = new Produto('Pizza Calabresa', dinheiro1, new PoliticaPrecoComDescontoPercentual(50));

cardapio.add(prod1);
cardapio.add(prod2);

Pedido pedidoPoliticas = new Pedido(c1, rest1);
pedidoPoliticas.adicionarItemPedido(prod1, 1);
pedidoPoliticas.adicionarItemPedido(prod2, 1);

System.debug('Total do pedido: ' + pedidoPoliticas.total.valorMonetario);
System.debug('');
*/


/*
Documento doc1 = new Documento('12345678901');
Documento doc2 = new Documento('45847548341');

Endereco end1 = new Endereco('Rua 1', '123', 'Casa', 'Sao Paulo');
Endereco end2 = new Endereco('Rua Azul', '13', 'APTO', 'SBC');

Cliente c1 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');
Cliente c2 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');


Dinheiro dinheiro1 = new Dinheiro(50.0);

Produto pizza1 = new Produto('Pizza Calabresa', dinheiro1, 

new PoliticaPrecoPadrao());
Produto pizza2 = new Produto('Pizza Mussarela', dinheiro1, new PoliticaPrecoPadrao());

List<Produto> cardapio = new List<Produto>();
cardapio.add(pizza1);
cardapio.add(pizza2);

CategoriaRestaurante cat = CategoriaRestaurante.PIZZARIA;
Restaurante rest1 = new Restaurante('Bella Pizza', end1, cat, cardapio);


System.debug('');
System.debug('ETAPA 4 - PARTE 1:');
System.debug(' Apenas criacao da Interface');
System.debug('');


System.debug('');
System.debug('ETAPA 4 - PARTE 2:');
System.debug('');

ProcessadorPedido processador = new ProcessadorPedido();

Pedido pedido = new Pedido(c1, rest1);

try{
    System.debug('Confirmar pedido sem itens');

} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}

rest1.adicionarProdutoCardapio(pizza1);

System.debug('Adicionar item');
processador.adicionarProduto(pedido, pizza1, 2);
System.debug('Total do pedido: ' + pedido.total.valorMonetario);

System.debug('Confirmar pedido valido');
processador.confirmarPedido(pedido);
System.debug('Status do pedido: ' + pedido.status);
*/

/*
System.debug('');
System.debug('ETAPA 4 - PARTE 3:');
System.debug('');

Pedido pedido2 = new Pedido(c1, rest1);
ProcessadorPedido processador2 = new ProcessadorPedido();
processador2.adicionarProduto(pedido2, pizza1, 2);


PoliticaDeFrete gratis = new FreteGratis();
processador2.aplicarPoliticaFrete(pedido2, gratis);

PoliticaDeFrete fixo = new FreteFixo(new Dinheiro(50.0));
processador2.aplicarPoliticaFrete(pedido2, fixo);

PoliticaDeFrete percentual = new FretePorPercentualDoTotal(10.0);

processador2.aplicarPoliticaFrete(pedido2, percentual);

System.debug('Status apos confirmar: ' + pedido2.status);

System.debug('');
System.debug('ETAPA 4 - PARTE 4:');
System.debug(' Apenas criacao da Interface');
System.debug('');

try{
    processador2.confirmarPedido(pedido2);
    processador2.finalizarPedido(pedido2);
    System.debug('Status do Pedido: ' + pedido2.status);

} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}

try {
    processador2.cancelarPedido(pedido2);

} catch(Exception e){
    System.debug('Erro: ' + e.getMessage());
}

try{
    processador2.confirmarPedido(pedido2);

} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}

try {
    processador2.adicionarProduto(pedido2, pizza2, 1);

} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}*/

// ====================================================================
// ====================================================================
// ====================================================================

// Documento doc1 = new Documento('12345678901');
// Documento doc2 = new Documento('45847548341');

// Endereco end1 = new Endereco('Rua 1', '123', 'Casa', 'Sao Paulo');
// Endereco end2 = new Endereco('Rua Azul', '13', 'APTO', 'SBC');

// Cliente c1 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');
// Cliente c2 = new Cliente('Neymar', doc1, end1, '(11)3943 2292');

// Dinheiro dinheiro1 = new Dinheiro(50.0);

// Produto pizza1 = new Produto('Pizza Calabresa', dinheiro1, 

// new PoliticaPrecoPadrao());
// Produto pizza2 = new Produto('Pizza Mussarela', dinheiro1, new PoliticaPrecoPadrao());

// List<Produto> cardapio = new List<Produto>();
// cardapio.add(pizza1);
// cardapio.add(pizza2);

// CategoriaRestaurante cat = CategoriaRestaurante.PIZZARIA;
// Restaurante rest1 = new Restaurante('Bella Pizza', end1, cat, cardapio);

// System.debug('');
// System.debug('ETAPA 5 - PARTE 1:');
// System.debug(' Apenas criacao da classe abstrata, sem implementacao de metodos');
// System.debug('');

// //System.debug('');
// //System.debug('ETAPA 5 - PARTE 2:');
// //System.debug('');

// Pedido pedido = new Pedido(c1, rest1);
// ProcessadorPedido processador = new ProcessadorPedido();
/*
try{
    processador.adicionarProduto(pedido, pizza1, 1);
    System.debug('Produto adicionado!');
} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}

try{
    processador.confirmarPedido(pedido);
} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}

System.debug(' ');
System.debug('Adicionar produto que já foi confirmado');
try{
    processador.adicionarProduto(pedido, pizza1, 1);
    System.debug('Produto adicionado!');
} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}

System.debug(' ');
System.debug('Finalizar pedido');
try{
    processador.finalizarPedido(pedido);
} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}

System.debug(' ');
System.debug('Cancelar algo já entregue');
try{
    processador.cancelarPedido(pedido);
} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}*/

/*
System.debug('');
System.debug('ETAPA 5 - PARTE 3:');
System.debug('');


Pedido pedidoNovo = new Pedido(c1, rest1);
System.debug('Estado inicial: ' + pedidonovo.status);    
System.debug('Estado inicial: ' + pedidonovo.estadoAtual);
pedidoNovo.confirmar();

try{
    System.debug('Status após confirmar: ' + pedidonovo.status);
    System.debug('Estado atual: ' + pedidonovo.estadoAtual);
} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}

try{
    System.debug('Marcando como entregue: ');
    pedidoNovo.finalizarEntrega();
} catch (Exception e){
    System.debug('Erro: ' + e.getMessage());
}

System.debug('Status final: ' + pedidonovo.status);
*/

// System.debug('');
// System.debug('ETAPA 5 - PARTE 3:');
// System.debug('Ja pude verificar com testes da etapa anterior');
// System.debug('');

// System.debug('');
// System.debug('ETAPA 5 - PARTE 5:');
// System.debug('');

// Pedido pedidoNovo = new Pedido(c1, rest1);
// pedidonovo.adicionarItemPedido(pizza1, 1);
// pedidoNovo.exibirResumo();

// pedidoNovo.confirmar();
// pedidoNovo.exibirResumo();
// pedidoNovo.finalizarEntrega();
// pedidoNovo.exibirResumo();


System.debug(' ');
System.debug(' ');
System.debug(' ');

System.debug('------ TESTE COMPLETO DO PROJETO ------');
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

processador.aplicarPoliticaFrete(pedido, new FreteFixo(new Dinheiro(10.0)));

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


// Pedido pedido5 = new Pedido(cliente, restaurante);
// pedido5.adicionarItemPedido(mussarela, 1);
// pedido5.adicionarItemPedido(calabresa, 1);

// List<Produto> produtos = new List<Produto>();
// produtos.add(mussarela);
// produtos.add(calabresa);
// Map<Produto, Integer> mapa = RelatorioService.gerarRelatorioProdutosMaisVendidos(produtos);

