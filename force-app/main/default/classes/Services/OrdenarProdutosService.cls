public with sharing class OrdenarProdutosService implements Comparable {
    
    public Produto produto;
    public Integer quantidade;

    public OrdenarProdutosService(Produto produto, Integer quantidade){
        this.produto = produto;
        this.quantidade = quantidade;
    }

    // ---------------------------------------------------------------------------------------

    public Integer compareTo(Object compareTo){
        OrdenarProdutosService produtoComparado = (OrdenarProdutosService) compareTo;

        if(this.quantidade < produtoComparado.quantidade) return 1;
        if(this.quantidade > produtoComparado.quantidade) return -1;
        return 0;
    }
}