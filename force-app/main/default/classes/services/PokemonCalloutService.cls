public with sharing class PokemonCalloutService {
    
    public static void insertAllPokemons(){

        String endpoint = 'https://pokeapi.co/api/v2/pokemon';

        List<Pokemon__c> pokemonList = new List<Pokemon__c>();
        Boolean validator = true;
        while (validator){

            HttpResponse response = PokemonCallout.makeCalloutToPokemonAPI(endpoint);
            if (response == null){
                System.debug('Error: Sem respostas da API');
                break;
            }

            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            
            System.debug('URL: ' + endpoint);
            
            List<Object> nameAndUrl = (List<Object>) result.get('results');
            
            if (response.getStatusCode() == 200){
                for (Object obj : nameAndUrl){
                    
                    Map<String, Object> newMap = (Map<String, Object>) obj;
                    
                    Pokemon__c pokemon = new Pokemon__c();
                    pokemon.Name = (String) newMap.get('name');
                    pokemon.Url__c = (String) newMap.get('url');
                    
                    pokemonList.add(pokemon);
                }
                endpoint = (String) result.get('next');
                if (String.isEmpty(endpoint)){
                    validator = false;
                    break;
                }
            }    
            else{
                System.debug('response: ' + response);    
            }

        }
        
        insert pokemonList;
    }
}
