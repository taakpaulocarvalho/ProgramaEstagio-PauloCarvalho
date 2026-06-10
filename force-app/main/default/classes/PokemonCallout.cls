public with sharing class PokemonCallout {

        public static HttpResponse makeCalloutToPokemonAPI(String endpoint){

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(endpoint);
        request.setMethod('GET');

        request.setHeader('Content-Type', 'application/json');
        request.setHeader('User-Agent', 'MyPokedexApp/1.0');

        try {
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200){

                return response;
            }    
            else{
                return null;   
            }        
        }catch(Exception e){
            System.debug('Error: ' + e.getMessage());
            return null;
        }
    }
}