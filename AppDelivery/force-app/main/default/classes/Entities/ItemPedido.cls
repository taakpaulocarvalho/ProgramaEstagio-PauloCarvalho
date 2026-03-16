public with sharing class ItemPedido extends EntidadeBase{

    public Produto produto { get; private set; }
    public Integer quantidade { get; private set; }
    public Dinheiro subtotal { get; private set; }

    private ItemPedido(Produto produto, Integer quantidade){
        super();
        if(produto == null || produto.calcularPrecoFinal().valorMonetario < 0){
            throw new IllegalArgumentException('O produto deve ter um preço válido!');
        }
        
        if(quantidade <= 0)
            throw new IllegalArgumentException('Quantidade deve ser maior que zero!');
        
        this.produto = produto;
        this.quantidade = quantidade;
        this.subtotal = calcularSubtotal();
    }


    // ---------------------------------------------------------------------------

    // METODO PARA INSTANCIAR UM ITEMPEDIDO QUE ESTA PRIVATE
    public static ItemPedido criarItemPedido(Produto produto, Integer quantidade){
        
        if(produto == null || produto.calcularPrecoFinal().valorMonetario < 0)
            throw new IllegalArgumentException('Verifique o produto é VAZIO ou a quantidade é menor ou igual a 0!');

        return new ItemPedido(produto, quantidade);
    }

    public Dinheiro calcularSubtotal(){
        return produto.calcularPrecoFinal().Multiplicar(this.quantidade);
    }

    public Integer adicionarQuantidade(Integer quantidade){
        if (quantidade <= 0){
            throw new IllegalArgumentException('Quantidade deve ser maior que zero!');
        }

        this.quantidade += quantidade;
        subtotal = calcularSubtotal();
        return this.quantidade;
    }

    public void atualizarQuantidade(Integer quantidade){
        if (quantidade <= 0){
            throw new IllegalArgumentException('Quantidade deve ser maior que zero!');
        }

        this.quantidade = quantidade;
        this.subtotal = calcularSubtotal();
    }
}