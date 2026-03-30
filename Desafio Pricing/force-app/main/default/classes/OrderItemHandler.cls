public with sharing class OrderItemHandler extends TriggerHandler{

    public override void beforeInsert(){
        aplicaImposto((List<OrderItem>) Trigger.new);
        aplicaFrete((List<OrderItem>) Trigger.new);
        aplicaMargem((List<OrderItem>) Trigger.new);
        validaParametrosObrigatorios((List<OrderItem>) Trigger.new);
        calculaPreco((List<OrderItem>) Trigger.new);
    }

    public override void beforeUpdate(){
        aplicaImposto((List<OrderItem>) Trigger.new);
        aplicaFrete((List<OrderItem>) Trigger.new);
        aplicaMargem((List<OrderItem>) Trigger.new);
        validaParametrosObrigatorios((List<OrderItem>) Trigger.new);
        calculaPreco((List<OrderItem>) Trigger.new);
    }

    private void aplicaImposto(List<OrderItem>  novosItens){

        Set<Id> idsPedidos = new Set<Id>();
        Set<Id> idsProdutos = new Set<Id>();

        //COLETAR IDS DOS PEDIDOS E PRODUTOS
        for(OrderItem item : novosItens){

            if (item.OrderId != null) idsPedidos.add(item.OrderId);
            if (item.Product2Id != null) idsProdutos.add(item.Product2Id);
        }

        //BUSCAR OS DADOS DO PEDIDO
        Map<Id, Order> pedidosMapa = new Map<id, Order>([
                SELECT Id, Centro_Distribuicao__c, Endereco__r.Cidade__r.Estado__c
                FROM Order
                WHERE Id IN :idsPedidos
        ]);

        Set<Id> idsCentrosDistribuicao = new Set<Id>();
        Set<Id> idsEstados = new Set<Id>();
        for (Order pedido : pedidosMapa.values()){
            if (pedido.Centro_Distribuicao__c != null) idsCentrosDistribuicao.add(pedido.Centro_Distribuicao__c);
            if (pedido.Endereco__r != null && pedido.Endereco__r.Cidade__r != null) idsEstados.add(pedido.Endereco__r.Cidade__r.Estado__c);
        }

        //BUSCA DE IMPOSTOS APROVADOS PRESENTES NO BANCO
        List<Imposto__c> impostosNoBanco = [SELECT Id, Produto__c, Centro_Distribuicao__c, Estado__c, Imposto_Sobre_Custo__c
                                            FROM Imposto__c
                                            WHERE Status__c = 'Aprovado'
                                            AND Produto__c IN :idsProdutos
                                            AND Centro_Distribuicao__c IN :idsCentrosDistribuicao
                                            AND Estado__c IN :idsEstados
                                            ORDER BY CreatedDate DESC
        ];
       
       //MAPEIA IMPOSTOS ENCONTRADOS 
        Map<String, Decimal> mapaImpostoSobreCusto = new Map<String, Decimal>();
        for (Imposto__c imposto : impostosNoBanco){
            String chave = '' + String.valueOf(imposto.Produto__c) + String.valueOf(imposto.Centro_Distribuicao__c) + String.valueOf(imposto.Estado__c);
            mapaImpostoSobreCusto.put(chave, imposto.Imposto_Sobre_Custo__c);
        }

        //APLICA IMPOSTO SOBRE PRODUTO DO PEDIDO
        for (OrderItem item : novosItens){
            Order pedido = pedidosMapa.get(item.OrderId);

            //PEGA O ESTADO NAVEGANDO PELO RELACIONAMENTO DO PEDIDO
            Id idEstado = (pedido != null && pedido.Endereco__r != null && pedido.Endereco__r.Cidade__r != null) ? pedido.Endereco__r.Cidade__r.Estado__c : null;

            //CHAVE PARA O ITEM ATUAL
            String chaveBusca = '' + item.Product2Id + pedido.Centro_Distribuicao__c + idEstado;
            
            //VERIFICA SE EXISTE IMPOSTO PARA O ITEM ATUAL
            if (mapaImpostoSobreCusto.containsKey(chaveBusca)){
                item.Porcentagem_Imposto__c = mapaImpostoSobreCusto.get(chaveBusca);
            }
        }
    }

    private void aplicaFrete(List<OrderItem>  novosItens){

        Set<Id> idsPedidos = new Set<Id>();
        Set<Id> idsProdutos = new Set<Id>();

        for (OrderItem item : novosItens){
            if (item.OrderId != null) idsPedidos.add(item.OrderId);
            if (item.Product2Id != null) idsProdutos.add(item.Product2Id);
        }

        //BUSCAR OS DADOS DO PEDIDO
        Map<Id, Order> pedidosMapa = new Map<id, Order>([
                SELECT Id, Centro_Distribuicao__c, Endereco__r.Cidade__c,
                                                   Endereco__r.Cidade__r.Estado__c,
                                                   Endereco__r.Cidade__r.Estado__r.Pais__c
                FROM Order
                WHERE Id IN :idsPedidos
        ]);

        //BUSCAR DADO DO PRODUTO
        Map<Id, Product2> produtosMapa = new Map<Id, Product2>([
                SELECT Id, Hierarquia_Produto__c
                FROM Product2
                WHERE Id IN :idsProdutos
        ]);


        Set<Id> idsCidade = new Set<Id>();
        Set<Id> idsEstados = new Set<Id>();
        Set<Id> idsPaises = new Set<Id>();
        Set<Id> idsHierarquias = new Set<Id>();
        Set<Id> idsCentroDistribuicao = new Set<Id>();

        //ATRIBUI OS IDS DOS PARAMETROS PARA BUSCAR OS FRETES NO BANCO
        for (Product2 produto : produtosMapa.values()){
            if (produto.Hierarquia_Produto__c != null) idsHierarquias.add(produto.Hierarquia_Produto__c);
        }

        //ATRIBUI OS IDS DOS PARAMETROS PARA BUSCAR OS FRETES NO BANCO
        for (Order pedido : pedidosMapa.values()){
            if (pedido.Endereco__r != null && pedido.Endereco__r.Cidade__c != null){
                idsCidade.add(pedido.Endereco__r.Cidade__c);
                
                if (pedido.Endereco__r.Cidade__r.Estado__c != null){
                    idsPaises.add(pedido.Endereco__r.Cidade__r.Estado__r.Pais__c);
                }
            }    
            if (pedido.Centro_Distribuicao__c != null) idsCentroDistribuicao.add(pedido.Centro_Distribuicao__c);
        }


        //BUSCAR FRETES PRESENTES NO BANCO
        List<Frete__c> fretesNoBanco = [SELECT Id, Produto__c, Hierarquia_Produto__c, Centro_Distribuicao__c, Cidade__c, Estado__c, Pais__c, Valor__c 
                                            FROM Frete__c
                                            WHERE Status__c = 'Aprovado'
                                            AND (Centro_Distribuicao__c IN :idsCentroDistribuicao)
                                            AND (Produto__c IN :idsProdutos OR Hierarquia_Produto__c IN :idsHierarquias)   
                                            AND (Cidade__c IN :idsCidade OR Estado__c IN :idsEstados OR Pais__c IN :idsPaises)
                                            ORDER BY CreatedDate DESC];


        //LOGICA DE ESPECIFIDADE
        for (OrderItem item : novosItens){

            Decimal valorFreteSelecionado = null;
            Integer maiorEspecifidade = -1;

            if (item.OrderId != null && item.Product2Id != null){
                Order pedido = pedidosMapa.get(item.OrderId);
                Product2 produto = produtosMapa.get(item.Product2Id);

                //LOOP PARA PERCORRER TODOS OS FRETES NO BANCO E SELECIONAR O MAIS ESPECIFICO
                for (Frete__c frete : fretesNoBanco){

                    //VERIFICA SE O FRETE ATENDE AO PEDIDO
                    Boolean atendeCD = (frete.Centro_Distribuicao__c != null && frete.Centro_Distribuicao__c == pedido.Centro_Distribuicao__c);
                    Boolean atendeProduto = (frete.Produto__c != null && frete.Produto__c == produto.Id);
                    Boolean atendeHierarquia = (frete.Hierarquia_Produto__c != null && frete.Hierarquia_Produto__c == produto.Hierarquia_Produto__c);
                    Boolean atendeCidade = (frete.Cidade__c != null && frete.Cidade__c == pedido.Endereco__r.Cidade__c);
                    Boolean atendeEstado = (frete.Estado__c != null && frete.Estado__c == pedido.Endereco__r.Cidade__r.Estado__c);
                    Boolean atendePais = (frete.Pais__c != null && frete.Pais__c == pedido.Endereco__r.Cidade__r.Estado__r.Pais__c);

                    //SE ATENDE OS PARAMETROS ESPECIFICOS DO PEDIDO APLICA A LOGICA DE ESPECIFIDADE
                    if (atendeCD && (atendeProduto || atendeHierarquia) && (atendeCidade || atendeEstado || atendePais)){
                        
                        //FAZ UM SOMATORIO PARA VERIFICAR A ESPECIFIDADE DO FRETE DE ACORDO COM OS PARAMETROS
                        Integer especifidade = 0;
                        if (atendeProduto) especifidade += 2000;
                        else if (atendeHierarquia) especifidade += 1000;

                        if (atendeCidade) especifidade += 30;
                        else if (atendeEstado) especifidade += 20;
                        else if (atendePais) especifidade += 10;
                        
                        if (especifidade > maiorEspecifidade){
                            maiorEspecifidade = especifidade;
                            valorFreteSelecionado = frete.Valor__c;
                        }
                    }
                }
            }

            //ATRIBUI O FRETE SELECIONADO AO CAMPO VALOR DE FRETE EM PRODUTO DO PEDIDO
            if (valorFreteSelecionado != null){
                item.Valor_Frete__c = valorFreteSelecionado;
            }
        }
    }

    private void aplicaMargem(List<OrderItem> novosItens){

        Set<Id> idsPedidos = new Set<Id>();
        Set<Id> idsProdutos = new Set<Id>();

        for (OrderItem item : novosItens){
            if (item.OrderId != null) idsPedidos.add(item.OrderId);
            if (item.Product2Id != null) idsProdutos.add(item.Product2Id);
        }

        //BUSCAR OS DADOS DO PEDIDO
        Map<Id, Order> pedidosMapa = new Map<Id, Order>([SELECT Id, Account.Grupo_Clientes__c, Centro_Distribuicao__c,
                                                             Endereco__r.Cidade__c, Endereco__r.Cidade__r.Estado__c, Endereco__r.Cidade__r.Estado__r.Pais__c
                                                         FROM Order
                                                         WHERE Id IN :idsPedidos]);

        //BUSCAR OS DADOS DO PRODUTO
        Map<Id, Product2> produtosMapa = new Map<Id, Product2>([SELECT Id, Hierarquia_Produto__c
                                                                FROM Product2
                                                                WHERE Id IN :idsProdutos]);

        Set<Id> idsHierarquias = new Set<Id>();
        Set<Id> idsContas = new Set<Id>();
        Set<Id> idsGruposConta = new Set<Id>();
        Set<Id> idsCentrosDistribuicao = new Set<Id>();
        Set<Id> idsCidades = new Set<Id>();
        Set<Id> idsEstados = new Set<Id>();
        Set<Id> idsPaises = new Set<Id>();

        //ATRIBUI OS IDS DOS PARAMETROS DO PRODUTO PARA BUSCAR AS MARGENS NO BANCO
        for (Product2 produto : produtosMapa.values()){
            
            if (produto.Hierarquia_Produto__c != null) idsHierarquias.add(produto.Hierarquia_Produto__c);   
        }

        //ATRIBUI OS IDS DOS PARAMETROS DO PEDIDO PARA BUSCAR AS MARGENS NO BANCO
        for (Order pedido : pedidosMapa.values()){
            
            if (pedido.AccountId != null) idsContas.add(pedido.AccountId);
            if (pedido.Account.Grupo_Clientes__c != null) idsGruposConta.add(pedido.Account.Grupo_Clientes__c);
            if (pedido.Centro_Distribuicao__c != null) idsCentrosDistribuicao.add(pedido.Centro_Distribuicao__c);

            if (pedido.Endereco__r != null){
                if (pedido.endereco__r.Cidade__c != null) idsCidades.add(pedido.endereco__r.Cidade__c);
                if (pedido.endereco__r.Cidade__r.Estado__c != null) idsEstados.add(pedido.endereco__r.Cidade__r.Estado__c);
                if (pedido.endereco__r.Cidade__r.Estado__r.Pais__c != null) idsPaises.add(pedido.endereco__r.Cidade__c);
            }
        }

        //BUSCAR MARGENS PRESENTES NO BANCO
        List<Margem__c> margensNoBanco = [SELECT Id, Produto__c, Hierarquia_Produto__c, Centro_Distribuicao__c, Conta__c, Grupo_Conta__c, Cidade__c, Estado__c, Pais__c, Valor__c
                                                 FROM Margem__c
                                                 WHERE Status__c = 'Aprovado'
                                                 AND (Centro_Distribuicao__c IN :idsCentrosDistribuicao)
                                                 AND (Produto__c IN :idsProdutos OR Hierarquia_Produto__c IN :idsHierarquias)
                                                 AND (Conta__c IN :idsContas OR Grupo_Conta__c IN :idsGruposConta)
                                                 AND (Cidade__c IN :idsCidades OR Estado__c IN :idsEstados OR Pais__c IN :idsPaises)
                                                 ORDER BY CreatedDate DESC];


        //LOGICA DE ESPECIFIDADE
        for (OrderItem item : novosItens){
            Order pedido = pedidosMapa.get(item.OrderId);
            Product2 produto = produtosMapa.get(item.Product2Id);
            
            Decimal valorMargemSelecionado = null;
            Integer maiorEspecifidade = -1;

            for (Margem__c margem : margensNoBanco){

                //VERIFICA SE A MARGEM ATENDE AO PEDIDO
                Boolean atendeCD = (margem.Centro_Distribuicao__c == pedido.Centro_Distribuicao__c);
                Boolean atendeProduto = (margem.Produto__c != null && margem.Produto__c == item.Product2Id);
                Boolean atendeHierarquia = (margem.Hierarquia_Produto__c != null && margem.Hierarquia_Produto__c == produto.Hierarquia_Produto__c);
                Boolean atendeCidade = (margem.Cidade__c != null && margem.Cidade__c == pedido.Endereco__r.Cidade__c);
                Boolean atendeEstado = (margem.Estado__c != null && margem.Estado__c == pedido.Endereco__r.Cidade__r.Estado__c);
                Boolean atendePais = (margem.Pais__c != null && margem.Pais__c == pedido.Endereco__r.Cidade__r.Estado__r.Pais__c);
                Boolean atendeConta = (margem.Conta__c != null && margem.Conta__c == pedido.AccountId);
                Boolean atendeGrupoConta = (margem.Grupo_Conta__c != null && margem.Grupo_Conta__c == pedido.Account.Grupo_Clientes__c);

                //SE ATENDE OS PARAMETROS ESPECIFICOS DO PEDIDO APLICA A LOGICA DE ESPECIFIDADE
                if (atendeCD && (atendeProduto || atendeHierarquia) && (atendeConta || atendeGrupoConta) && (atendeCidade || atendeEstado || atendePais )){
                    
                    Integer especifidade = 0;

                    //FAZ UM SOMATORIO PARA VERIFICAR A ESPECIFIDADE DA MARGEM DE ACORDO COM OS PARAMETROS
                    if (atendeProduto) especifidade += 2000;
                    else if (atendeHierarquia) especifidade += 1000;

                    if (atendeConta) especifidade += 200;
                    else if (atendeGrupoConta) especifidade += 100;

                    if (atendeCidade) especifidade += 30;
                    else if (atendeEstado) especifidade += 20;
                    else if (atendePais) especifidade += 10;
                    
                    if (especifidade > maiorEspecifidade){
                        maiorEspecifidade = especifidade;
                        valorMargemSelecionado = margem.Valor__c;
                    }
                }
            }

            //ATRIBUI A MARGEM SELECIONADA AO CAMPO PORCENTAGEM DE MARGEM EM PRODUTO DO PEDIDO
            if (valorMargemSelecionado != null){
                item.Porcentagem_Margem__c = valorMargemSelecionado;
            }
        }
    }

    private void validaParametrosObrigatorios(List<OrderItem> novosItens){

        Set<Id> idsProdutos = new Set<Id>();
        for (OrderItem item : novosItens){
            if (item.Product2Id != null) idsProdutos.add(item.Product2Id);
        }

        //BUSCA O CUSTO DE PRODUCAO DE CADA PRODUTO
        Map<Id, Product2> mapaProdutos = new Map<Id, Product2>([
            SELECT Id, Custo_Producao__c 
            FROM Product2
            WHERE Id IN :idsProdutos
        ]);

        for (OrderItem item : novosItens){

            Product2 produto = mapaProdutos.get(item.Product2Id);

            //VERIFICA SE EXISTE CUSTO DE PRODUCAO NO CADASTRO DO PRODUTO
            Boolean temCusto = (produto != null && produto.Custo_Producao__c != null);

            //VERIFICA SE O PRODUTO TEM TODOS OS PARAMETROS OBRIGATORIOS
            Boolean temImposto = (item.Porcentagem_Imposto__c != null);
            Boolean temFrete = (item.Valor_Frete__c != null);
            Boolean temMargem = (item.Porcentagem_Margem__c != null);

            //SE EXISTE ALGUM PARAMETRO FALTANDO, ADICIONA ERRO AO PRODUTO DO PEDIDO
            if (!temCusto || !temImposto || !temFrete || !temMargem){
                item.addError('Não está autorizada a venda deste produto devido a falta de parâmetros, entre em contato com o time de pricing.');
            }
            else{
                item.Custo_Producao__c = produto.Custo_Producao__c;
            }
        }
    }

    private void calculaPreco(List<OrderItem> novosItens){

        Set<Id> idsProdutos = new Set<Id>();
        for (OrderItem item : novosItens){
            if (item.Product2Id != null) idsProdutos.add(item.Product2Id);
        }

        //MAPEIA OS CUSTOS DE PRODUCAO DOS PRODUTOS
        Map<Id, Product2> mapaProdutos = new Map<Id, Product2>([
            SELECT Id, Custo_Producao__c 
            FROM Product2
            WHERE Id IN :idsProdutos
        ]);

        //FAZ O CALCULO PARA CADA PRODUTO NO PEDIDO
        for (OrderItem item : novosItens){
            
            Product2 produto = mapaProdutos.get(item.Product2Id);

            //VERIFICANDO SE CUSTO DE PRODUCAO EXISTE PARA GARINTIR QUE O CALCULO SEJA REALIZADO
            if (produto != null && produto.Custo_Producao__c != null){
                item.Custo_Producao__c = produto.Custo_Producao__c;
            }

            //CALCULO SO E FEITO SE TODOS OS PARAMETROS FOREM PASSADOS
            if (item.Custo_Producao__c != null && item.Porcentagem_Imposto__c != null && item.Porcentagem_Margem__C != null && item.Porcentagem_Imposto__c != null){
                
                Decimal custoProducao = item.Custo_Producao__c;
                Decimal frete = item.Valor_Frete__c;
                Decimal imposto = item.Porcentagem_Imposto__c / 100;
                Decimal margem = item.Porcentagem_Margem__c  / 100;

                //PRECO SEM MARGEM
                Decimal precoSemMargem = (custoProducao + frete) * (1 + imposto);
                item.Preco_Sem_Margem__c = precoSemMargem;

                //PRECO FINAL
                Decimal precoFinal = (custoProducao + frete) * (1 + imposto) * (1 + margem);
                item.Preco_Final__c = precoFinal;

                //SE O PRECO FINAL FOR VALIDO, CALCULA O DESCONTO
                if (precoFinal > 0 && item.Preco_Venda__c != null){

                    Decimal desconto = (precoFinal - item.Preco_Venda__c) / precoFinal;
                    item.Desconto__c = desconto * 100;
                }
                else{
                    item.Desconto__c = 0.0;
                }
            } 
        }
    }

    private void validaQuantidadePrecoZerados(List<OrderItem> novosItens){
    
        for (OrderItem item : novosItens){
            
            Boolean quantidadeInvalida = item.Quantidade__c == null || item.Quantidade__c <= 0;
            Boolean precoInvalido = item.Preco_Venda__c == null || item.Preco_Venda__c <= 0;

            if (quantidadeInvalida || precoInvalido) item.addError('Não é possível cadastrar produtos do pedido com quantidade ou preços zerados.');
        }
    }
}