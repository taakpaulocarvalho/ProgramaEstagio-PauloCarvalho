public with sharing class CalculaEspecifidadeService {

    public static Integer calculaEspecifidade(Boolean atendeProduto, Boolean atendeHierarquia, Boolean atendeCidade, Boolean atendeEstado, 
                                                Boolean atendePais, Boolean atendeConta, Boolean atendeGrupoConta){

        Integer especifidade = 0;

        //FAZ UM SOMATORIO PARA VERIFICAR A ESPECIFIDADE DA MARGEM DE ACORDO COM OS PARAMETROS
        if (atendeProduto) especifidade += 2000;
        else if (atendeHierarquia) especifidade += 1000;

        if (atendeConta) especifidade += 200;
        else if (atendeGrupoConta) especifidade += 100;

        if (atendeCidade) especifidade += 30;
        else if (atendeEstado) especifidade += 20;
        else if (atendePais) especifidade += 10;

        return especifidade;
    }
}