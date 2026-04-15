@isTest
private class OrderTest {

    @TestSetup
    static void makeData(){
        
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
        Product2 produto = new Product2(Hierarquia_Produto__c = hierarquiaProduto.Id, Custo_Producao__c = 100);
        produto = (Product2) factory.createSObject(produto);
        insert produto;


        //CRIANDO DADOS PARA IMPOSTO
        Imposto__c imp = (Imposto__c) factory.createSObject(new Imposto__c(Centro_Distribuicao__c = centroDistribuicao.Id, Estado__c = estado.Id, Produto__c = produto.Id, Imposto_Sobre_Custo__c = 10));
        insert imp;

        //CRIANDO DADOS PARA MARGEM
        Margem__c margem = new Margem__c(Centro_Distribuicao__c = centroDistribuicao.Id, Conta__c = account.Id, Produto__c = produto.Id, Cidade__c = cidade.Id, Valor__c = 20);
        margem = (Margem__c) factory.createSObject(margem);
        insert margem;

        //CRIANDO DADOS PARA FRETE
        Frete__c frete = new Frete__c(Centro_Distribuicao__c = centroDistribuicao.Id, Cidade__c = cidade.Id, Produto__c = produto.Id, Valor__c = 100, Status__c = 'Aprovado');
        frete = (Frete__c) factory.createSObject(frete);
        insert frete;

        Id standardPbId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(Product2Id = produto.Id, Pricebook2Id = standardPbId, UnitPrice = 100, IsActive = true);
        insert pbe;

        Order pedido = new Order(AccountId = account.Id, Centro_Distribuicao__c = centroDistribuicao.Id, Condicao_Pagamento__c = condicaoPagamento.Id, Endereco__c = enderecoConta.Id, Pricebook2Id = pbe.Pricebook2Id);
        pedido = (Order) factory.createSObject(pedido);
        insert pedido;

        OrderItem item = new OrderItem(OrderId = pedido.Id, Product2Id = produto.Id, Quantity = 10, UnitPrice = 1000000, PricebookEntryId = pbe.Id);
        item = (OrderItem) TestFactorySObject.getInstance().createSObject(item);
        insert item;
    }

    @isTest
    static void validaAlteracoesTest(){

        Order pedido = [SELECT Id, AccountId, Centro_Distribuicao__c, Condicao_Pagamento__c, Endereco__c FROM Order LIMIT 1];

        Test.startTest();

        pedido.Status = 'Activated';
        update pedido;

        try{
            pedido.AccountId = null;
            pedido.Centro_Distribuicao__c = null;
            pedido.Condicao_Pagamento__c = null;
            pedido.Endereco__c = null;
            pedido.Status = 'Draft';

            update pedido;
            System.assert(false, 'Não é possível atualizar um pedido que ja está Ativado');
        }
        catch (DmlException e){
            System.assert(e.getDmlMessage(0).contains('Não é possível fazer qualquer alteração em um pedido que está Ativo'), 'Erro: ' + e.getMessage());
        }

        Test.stopTest();
    }

    @isTest
    static void recalculaPrecoTest(){

        Centro_Distribuicao__c centroRecalculo = new Centro_Distribuicao__c();
        centroRecalculo = (Centro_Distribuicao__c) TestFactorySObject.getInstance().createSObject(centroRecalculo);
        insert centroRecalculo;

        Order pedido = [SELECT Id FROM Order LIMIT 1];
        pedido.Centro_Distribuicao__c = centroRecalculo.Id;

        Test.startTest();

        try{
            update pedido;
            System.assert(false, 'Não é possível recalcular o preço de um pedido que já está Ativado');
        }
        catch (Exception e){
            System.assert(e.getMessage().contains('Erro ao atualizar o pedido e seus itens devido a falta de parâmetros, entre em contato com o time de pricing.'), 'Erro: ' + e.getMessage());
        }

        Test.stopTest();
    }


}