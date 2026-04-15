
@isTest
private class OrderItemTest {

    @TestSetup
    static void makeData() {
        

        TestFactorySObject factory = TestFactorySObject.getInstance();

        Grupo_Conta__c grupoConta = new Grupo_Conta__c();
        grupoConta = (Grupo_Conta__c) factory.createSObject(grupoConta);
        insert grupoConta;

        Account account = new Account(Grupo_Clientes__c = grupoConta.Id);
        account = (Account) factory.createSObject(account);
        insert account;

        Pais__c pais = new Pais__c();
        pais = (Pais__c) factory.createSObject(pais);
        insert pais;

        Estado__c estado = new Estado__c(Pais__c = pais.Id);
        estado = (Estado__c) factory.createSObject(estado);
        insert estado;

        Cidade__c cidade = new Cidade__c(Estado__c = estado.Id);
        cidade = (Cidade__c) factory.createSObject(cidade);
        insert cidade;

        Endereco_Conta__c enderecoConta = new Endereco_Conta__c(Conta__c = account.Id, Cidade__c = cidade.Id);
        enderecoConta = (Endereco_Conta__c) factory.createSObject(enderecoConta);
        insert enderecoConta;

        Centro_Distribuicao__c centroDistribuicao = new Centro_Distribuicao__c();
        centroDistribuicao = (Centro_Distribuicao__c) factory.createSObject(centroDistribuicao);
        insert centroDistribuicao;

        Condicao_Pagamento__c condicaoPagamento = new Condicao_Pagamento__c();
        condicaoPagamento = (Condicao_Pagamento__c) factory.createSObject(condicaoPagamento);
        insert condicaoPagamento;

        Hierarquia_Produto__c hierarquiaProduto = new Hierarquia_Produto__c();
        hierarquiaProduto = (Hierarquia_Produto__c) factory.createSObject(hierarquiaProduto);
        insert hierarquiaProduto;

        TriggerHandler.bypass('ProdutoHandler');
        Product2 produto = new Product2(Hierarquia_Produto__c = hierarquiaProduto.Id, Custo_Producao__c = 0);
        produto = (Product2) factory.createSObject(produto);
        insert produto;


        //CRIANDO DADOS PARA IMPOSTO
        Imposto__c imp = (Imposto__c) factory.createSObject(new Imposto__c(Centro_Distribuicao__c = centroDistribuicao.Id, Estado__c = estado.Id, Produto__c = produto.Id, Imposto_Sobre_Custo__c = 10));
        insert imp;

        //CRIANDO DADOS PARA MARGEM
        Margem__c margem = new Margem__c(Centro_Distribuicao__c = centroDistribuicao.Id, Conta__c = account.Id, Produto__c = produto.Id, Cidade__c = cidade.Id, Valor__c = 20);
        margem = (Margem__c) factory.createSObject(margem);
        insert margem;

        Margem__c margem2 = (Margem__c) factory.createSObject(new Margem__c(Centro_Distribuicao__C = centroDistribuicao.Id, Conta__c = account.Id, Hierarquia_Produto__c = hierarquiaProduto.Id, Estado__c = estado.Id, Valor__c = 40));
        insert margem2;

        Margem__c margem3 = (Margem__c) factory.createSObject(new Margem__c(Centro_Distribuicao__C = centroDistribuicao.Id, Conta__c = account.Id, Hierarquia_Produto__c = hierarquiaProduto.Id, Pais__c = pais.Id, Valor__c = 40));
        insert margem3;

        //CRIANDO DADOS PARA FRETE
        Frete__c frete = new Frete__c(Centro_Distribuicao__c = centroDistribuicao.Id, Cidade__c = cidade.Id, Produto__c = produto.Id, Valor__c = 100, Status__c = 'Aprovado');
        frete = (Frete__c) factory.createSObject(frete);
        insert frete;

        Frete__c frete2 = (Frete__c) factory.createSObject(new Frete__c(Centro_Distribuicao__c = centroDistribuicao.Id, Estado__c = estado.Id, Hierarquia_Produto__c = hierarquiaProduto.Id, Valor__c = 100, Status__c = 'Aprovado'));
        insert frete2;

        Frete__c frete3 = (Frete__c) factory.createSObject(new Frete__c(Centro_Distribuicao__c = centroDistribuicao.Id, Pais__c = pais.Id, Hierarquia_Produto__c = hierarquiaProduto.Id, Valor__c = 200, Status__c = 'Aprovado'));
        insert frete3;

        Id standardPbId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(Product2Id = produto.Id, Pricebook2Id = standardPbId, UnitPrice = 100, IsActive = true);
        insert pbe;

        //CRIANDO ORDER
        Order pedido = new Order(AccountId = account.Id, Centro_Distribuicao__c = centroDistribuicao.Id, Condicao_Pagamento__c = condicaoPagamento.Id, Endereco__c = enderecoConta.Id, Pricebook2Id = standardPbId);
        pedido = (Order) factory.createSObject(pedido);
        insert pedido;

        //CRIANDO ORDER ITEM
        // OrderItem item = new OrderItem(OrderId = pedido.Id, Product2Id = produto.Id, Quantity = 10, UnitPrice = 100, PricebookEntryId = pbe.Id);
        // item = (OrderItem) TestFactorySObject.getInstance().createSObject(item);
        // insert item;

    }

    @isTest
    static void calculaPrecoTest(){


        Order pedido = [SELECT Id FROM Order LIMIT 1];
        Product2 produto = [SELECT Id FROM Product2 LIMIT 1];
        PricebookEntry pbe = [SELECT Id from PricebookEntry LIMIT 1];

        OrderItem item = new OrderItem(OrderId = pedido.Id, Product2Id = produto.Id, Quantity = 10, UnitPrice = 100, PricebookEntryId = pbe.Id);
        item = (OrderItem) TestFactorySObject.getInstance().createSObject(item);
        
        Test.startTest();
        try{
            insert item;
            System.assert(false, 'Não é possível recalcular o preço de um pedido que já está Ativado');
        }
        catch (Exception e){
            System.assert(e.getMessage().contains('Erro ao atualizar o pedido e seus itens devido a falta de parâmetros, entre em contato com o time de pricing.'), 'Erro: ' + e.getMessage());
        }

        Test.stopTest();
    }

}