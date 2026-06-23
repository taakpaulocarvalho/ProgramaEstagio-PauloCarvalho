public with sharing class CalculateScoreService {

    public static Integer calculateScore(Boolean servesProduct, Boolean servesHierarchy, Boolean servesCity, Boolean servesState, 
                                                Boolean servesCountry, Boolean servesAccount, Boolean servesAccountGroup){

        Integer score = 0;

        //FAZ UM SOMATORIO PARA VERIFICAR A ESPECIFIDADE DA Margin DE ACORDO COM OS PARAMETROS
        if (servesProduct) score += 2000;
        else if (servesHierarchy) score += 1000;

        if (servesAccount) score += 200;
        else if (servesAccountGroup) score += 100;

        if (servesCity) score += 30;
        else if (servesState) score += 20;
        else if (servesCountry) score += 10;

        return score;
    }
}