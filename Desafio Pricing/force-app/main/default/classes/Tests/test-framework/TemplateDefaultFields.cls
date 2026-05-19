public with sharing class TemplateDefaultFields {
    public interface FieldDefaults {
        Map<String, Object> getFieldDefaults(Decimal countSObjectCreated);
    }

    public class UserDefaults implements FieldDefaults {
		public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated) {
			return new Map<String, Object>{
				'ExternalId__c' => '10' + countSObjectCreated,
				'Username' => 'test' + Datetime.now().getTime() +'@test.com',
				'LastName' => 'inquima',
				'Email' => 'inquima@inquima.com',
				'Alias' => 'inquima',
				'CommunityNickname' => 'inquima',
				'TimeZoneSidKey' => 'America/Sao_Paulo',
				'LocaleSidKey' => 'pt_BR',
				'EmailEncodingKey' => 'ISO-8859-1',
				'LanguageLocaleKey' => 'pt_BR'
			};
		}
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
                'ProductCode' => 'P- ' + countSObjectCreated,
                'ExternalId__c' => 'Product2' + countSObjectCreated
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
                'Delivery_Date__c' => Date.today().addDays(7),
                'ExternalId__c' => 'OrderExternalId' + countSObjectCreated

            };
        }
    }

    public class OrderItemDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'ExternalId__c' => 'OrderItemExternalId' + countSObjectCreated
            };
        }
    }


    public class PricebookEntryDefaults implements FieldDefaults {

        public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated){
            return new Map<String, Object>{
                'IsActive' => true,
                'ExternalId__c' => 'PricebookEntry' + countSObjectCreated
            };
        }
    }

    public class IntegrationSettingDefaults implements FieldDefaults {
		public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated) {
			return new Map<String, Object>{
				'Name' => 'IntegrationSettingName',
				'Method__c' => 'POST',
				'Endpoint__c' => 'Endpoint',
				'User__c' => UserInfo.getUserName(),
				'Password__c' => UserInfo.getUserName(),
				'Timeout__c' => 110000,
				'AccessToken__c' => 'AccessToken' + String.valueOf(Datetime.now()),
				'ClientId__c' => String.valueOf(Datetime.now()),
				'ClientSecret__c' => UserInfo.getUserName() + String.valueOf(Datetime.now()),
				'EndpointAccessToken__c' => 'EndpointAccessToken',
				'AccessTokenTime__c' => 360000,
				'LastAccessTokenTime__c' => Decimal.valueOf(Datetime.now().getTime())
			};
		}
	}
}