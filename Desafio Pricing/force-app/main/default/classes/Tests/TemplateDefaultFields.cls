public with sharing class TemplateDefaultFields {
    public interface FieldDefaults {
        Map<String, Object> getFieldDefaults(Decimal countSObjectCreated);
    }

    public class GrupoContaDefaults implements FieldDefaults {

        public Map <String, Object> getFieldDefaults(Decimal countSObjectCreated) {
            return new Map<String, Object>{
                'Name' => 'Grupo ' + countSObjectCreated,
                'Codigo__c' => 'GC ' + countSObjectCreated
            };
        }
    }

    public class AccountDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated) {
            return new Map<String, Object>{
                'Name' => 'Account ' + countSObjectCreated,
                'CNPJ__c' => '12345678910111' 
            };
        }
    }

    public class PaisDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'País ' + countSObjectCreated,
                'Sigla__c' => 'PA ' + countSObjectCreated
            };
        }
    }

    public class EstadoDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Estado ' + countSObjectCreated,
                'Sigla__c' => 'ES ' + countSObjectCreated
            };
        }
    }

    public class CidadeDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Cidade ' + countSObjectCreated,
                'Codigo_IBGE__c' => 'CID ' + countSObjectCreated
            };
        }
    }

    public class HierarquiaProdutoDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Hierarquia ' + countSObjectCreated,
                'Codigo__c' => 'HP ' + countSObjectCreated
            };
        }
    }

    public class Product2Defaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Produto ' + countSObjectCreated,
                'ProductCode' => 'P- ' + countSObjectCreated
            };
        }
    }

    public class PricebookEntryDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'IsActive' => true,
                'UnitPrice' => 10
            };
        }
    }

    public class EnderecoContaDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Endereço ' + countSObjectCreated,
                'Codigo__c' => 'EC ' + countSObjectCreated,
                'Logradouro__c' => 'Rua ' + countSObjectCreated,
                'CEP__c' => '12345-' + '678' + countSObjectCreated,
                'Bairro__c' => 'Bairro ' + countSObjectCreated
            };
        }
    }

    public class CondicaoPagamentoDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Condição ' + countSObjectCreated,
                'Codigo__c' => 'CP ' + countSObjectCreated
            };
        }
    }

    public class CentroDistribuicaoDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Centro ' + countSObjectCreated,
                'Codigo__c' => 'CD ' + countSObjectCreated
            };
        }
    }

    public class FreteDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Frete ' + countSObjectCreated,
                'Status__c' => 'Aprovado'
            };
        }
    }

    public class MargemDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Margem ' + countSObjectCreated,
                'Status__c' => 'Aprovado'
            };
        }
    }

    public class ImpostoDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Imposto ' + countSObjectCreated,
                'Status__c' => 'Aprovado'
            };
        }
    }

    public class OrderDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'EffectiveDate' => Date.today(),
                'Status' => 'Draft',
                'Tipo_Frete__c' => 'CIF',
                'Data_Entrega__c' => Date.today().addDays(7)

            };
        }
    }


}