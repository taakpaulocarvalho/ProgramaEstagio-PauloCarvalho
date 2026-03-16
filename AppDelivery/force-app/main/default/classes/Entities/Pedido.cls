public with sharing class Pedido extends EntidadeBase{

    public Cliente cliente { get; private set; }
    public Restaurante restaurante { get; private set; }
    private List<ItemPedido> itens = new List<ItemPedido>();
    public Dinheiro total { get; private set; }
    public Dinheiro frete { get; private set; }
    public EstadoPedido estadoAtual { get; private set; }

    public Pedido(Cliente cliente, Restaurante restaurante){
        super();
        this.cliente = cliente;
        this.restaurante = restaurante;
        this.total = new Dinheiro(0);
        this.frete = new Dinheiro(0);
        this.estadoAtual = new EstadoCarrinho();
    }
    
    // ---------------------------------------------------------------------------------------

    // ADICIONA PRODUTO AO PEDIDO
    public void adicionarItemPedido(Produto produto, Integer quantidade){
        
        this.estadoAtual.adicionarProduto(this, produto, quantidade);

        if (quantidade <= 0)
            throw new IllegalArgumentException('A quantidade deve ser maior que zero!');
        
        for (ItemPedido item : itens){

            if (item.produto.id == produto.id){
                
                item.adicionarQuantidade(quantidade);
                total = calcularTotal();
                System.debug('A quantidade de ' + item.produto.nome + ' foi aumentada com sucesso!');

                return;
            }
        } 

        itens.add(ItemPedido.criarItemPedido(produto, quantidade));
        System.debug('O pedido foi adicionado com sucesso!');

        total = calcularTotal();  
    }

    // REMOVE PRODUTO DO PEDIDO
    public void executarRemocao(Produto produto){

        this.estadoAtual.removerProduto(this, produto);

        for(Integer i = 0; i < itens.size(); i++){
            if (itens[i].produto.id == produto.id){
                itens.remove(i);
                total = calcularTotal();
                System.debug('O produto ' + produto.nome + ' foi removido com sucesso!');
                return;   
            }
        }
    }


    // ATUALIZA QUANTIDADE DO PRODUTO
    public void executaAlteraQuantidade(Produto produto, Integer quantidade){
        
        this.estadoAtual.removerProduto(this, produto);

        for (ItemPedido item : itens){
            if (item.produto.id == produto.id){
                item.atualizarQuantidade(quantidade);
                this.total = calcularTotal();
                System.debug('Quantidade atualizada!');
                return;
            } 
        }
    }

    // CALCULA O VALOR TOTAL DO PEDIDO
    public Dinheiro calcularTotal(){
        Dinheiro total = new Dinheiro(0);
        for (ItemPedido item : itens){
            total = total.Somar(item.calcularSubtotal());
        }
        
        this.total = total.Somar(frete);
        return total;
    }

    public void confirmar(){
        this.estadoAtual.confirmar(this);
    }

    public void cancelar(){
        this.estadoAtual.cancelar(this);
    }


    public void finalizarEntrega(){
        this.estadoAtual.marcarComoEntregue(this);
    }

    public void aplicarFrete(Dinheiro frete){
        this.frete = frete;
    }
    
    public List<ItemPedido>  getItens(){
        return new List<ItemPedido>(this.itens);
    }

    public void trocarEstado(EstadoPedido novoEstado){
        this.estadoAtual = novoEstado;
    }

    public String getNomeEstado(){
        
        return String.valueOf(this.estadoAtual).split(':')[0].replace('Estado', ' ');
    }


    //RESUMO COMPLETO DO PEDIDO
    public void exibirResumo(){

        System.debug('RESUMO DO PEDIDO');
        System.debug('Cliente: ' + cliente.nome);
        System.debug('Restaurante: ' + restaurante.nome);
        
        for (ItemPedido item : itens){
            System.debug('Produto: ' + item.produto.nome + ' - Quantidade: ' + item.quantidade + ' - Subtotal: ' + item.subtotal);
        }

        System.debug('Valor Total incluindo frete: ' + total);
        System.debug('Status do Pedido: ' + this.getNomeEstado());
    }
}






