public with sharing class Restaurante extends EntidadeBase{
    
    public String nome { get; private set; }
    public Endereco endereco { get; private set; }
    public CategoriaRestaurante categoria { get; private set; }
    private List<Produto> cardapio;
    
    public Restaurante(){
        super();
        this.cardapio = new List<Produto>();
    }

    public Restaurante(String nome, Endereco endereco, CategoriaRestaurante categoria, List<Produto> cardapio){   
        super();
        this.nome = nome;
        this.endereco = endereco;
        this.categoria = categoria;
        this.cardapio = (cardapio == null) ? new List<Produto>() : cardapio;
    }

    // ---------------------------------------------------------------------------------------

    // ADICIONA PRODUTO AO CARDAPIO DO RESTAURANTE
    public void adicionarProduto(Produto produto){
         
        Boolean produtoExiste = false;

        for (Produto prod : cardapio){
            
            produtoExiste = (prod.nome == produto.nome) ?  true : false;
            if (produtoExiste) break;
        }
        
        if (produtoExiste){
            System.debug('Produto ' + produto.nome + ' ja existe no cardapio!');
        }
        else{
            cardapio.add(produto);
            System.debug(produto +' adicionado com sucesso!');
        }
        
    }

    // EXIBE O CARDAPIO DO RESTAURANTE
    public void exibirCardapio(){

        if (cardapio == null || cardapio.isEmpty())
            System.debug('Nenhum produto no cardapio!');
        else{
            
            System.debug('CARDAPIO DO RESTAURANTE ' + nome);
        
            for(Integer i = 0; i < cardapio.size(); i++){
                System.debug('Produto ' + (i+1) + ': ' + cardapio[i].nome + ' - R$ ' + cardapio[i].calcularPrecoFinal());
            }
            
            System.debug('FIM DO CARDAPIO');
        }
    }

    // BUSCA PRODUTOS NO CARDAPIO
    public List<Produto> buscarProdutos(String termoBusca){

        List<Produto> produtos = new List<Produto>();

        for (Produto produto : cardapio){

            if (produto.nome.contains(termoBusca)){
                produtos.add(produto);
                System.debug('Produto adicionado!');
            } 
            else{
                System.debug('Produto ' + termoBusca + ' não encontrado!');
            }
        }
        return produtos;
    }

    // RETORNA O CARDAPIO DO RESTAURANTE QUE ESTA PRIVATE
    public List<Produto> getCardapio(){
        return cardapio;
    }
}