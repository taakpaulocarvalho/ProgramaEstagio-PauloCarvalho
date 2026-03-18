public Integer fibonacci(Integer n) {
    
    Integer atual = 0;
    Integer anterior = 1;
    Integer soma = 0;

    for (Integer i = 1; i <= n; i++){       
        
        soma = atual + anterior;
        
        anterior = atual;
        atual = soma;
    }

    return soma;
}