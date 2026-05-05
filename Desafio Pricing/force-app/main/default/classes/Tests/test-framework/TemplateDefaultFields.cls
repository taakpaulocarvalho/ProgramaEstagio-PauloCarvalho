public with sharing class TemplateDefaultFields {
    public interface FieldDefaults {
        Map<String, Object> getFieldDefaults(Decimal countSObjectCreated);
    }

    public class AccountGroupDefaults implements FieldDefaults {

        public Map <String, Object> getFieldDefaults(Decimal countSObjectCreated) {
            return new Map<String, Object>{
                'Name' => 'Grupo ' + countSObjectCreated,
                'Code__c' => 'GC ' + countSObjectCreated
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

    public class CountryDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'País ' + countSObjectCreated,
                'Acronym__c' => 'PA ' + countSObjectCreated
            };
        }
    }

    public class StateDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Estado ' + countSObjectCreated,
                'Acronym__c' => 'ES ' + countSObjectCreated
            };
        }
    }

    public class CityDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Cidade ' + countSObjectCreated,
                'IBGE_Code__c' => 'CID ' + countSObjectCreated
            };
        }
    }

    public class ProductHierarchyDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Hierarquia ' + countSObjectCreated,
                'Code__c' => 'HP ' + countSObjectCreated
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

    public class AccountAddressDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Endereço ' + countSObjectCreated,
                'Code__c' => 'EC ' + countSObjectCreated,
                'Public_Space__c' => 'Rua ' + countSObjectCreated,
                'CEP__c' => '12345-' + '678' + countSObjectCreated,
                'Neighborhood__c' => 'Neighborhood ' + countSObjectCreated
            };
        }
    }

    public class PaymentTermsDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Condição ' + countSObjectCreated,
                'Code__c' => 'CP ' + countSObjectCreated
            };
        }
    }

    public class DistributionCenterDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Centro ' + countSObjectCreated,
                'Code__c' => 'CD ' + countSObjectCreated
            };
        }
    }

    public class FreightDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Freight ' + countSObjectCreated,
                'Status__c' => 'Aprovado'
            };
        }
    }

    public class MarginDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Margin ' + countSObjectCreated,
                'Status__c' => 'Aprovado'
            };
        }
    }

    public class TaxDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'Name' => 'Tax ' + countSObjectCreated,
                'Status__c' => 'Aprovado'
            };
        }
    }

    public class OrderDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'EffectiveDate' => Date.today(),
                'Status' => 'Draft',
                'Type_Of_Shipping__c' => 'CIF',
                'Delivery_Date__c' => Date.today().addDays(7)

            };
        }
    }

    public class OrderItemDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
            };
        }
    }

}