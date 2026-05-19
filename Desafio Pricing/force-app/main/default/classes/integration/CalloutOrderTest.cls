@IsTest
public with sharing class CalloutOrderTest {
	@TestSetup
	static void makeData() {
		TestFactorySObject sobjectFactory = TestFactorySObject.getInstance();

		Account_Group__c newAccountGroup = (Account_Group__c) sobjectFactory.createSObject(new Account_Group__c());
        insert newAccountGroup;

		Account newAccount = (Account)sobjectFactory.createSObject(new Account(Customer_Group__c = newAccountGroup.Id));
		insert newAccount;

		Country__c newCountry = (Country__c) sobjectFactory.createSObject(new Country__c());
        insert newCountry;

        State__c newState = (State__c) sobjectFactory.createSObject(new State__c(Country__c = newCountry.Id));
        insert newState;

        City__c newCity = (City__c) sobjectFactory.createSObject(new City__c(State__c = newState.Id));
        insert newCity;

        Account_Address__c newAccountAddress = (Account_Address__c) sobjectFactory.createSObject(new Account_Address__c(Account__c = newAccount.Id, City__c = newCity.Id));
        insert newAccountAddress;

        Distribution_Center__c newDC = (Distribution_Center__c) sobjectFactory.createSObject(new Distribution_Center__c());
        insert newDC;

        Payment_Terms__c newPaymentTerms = (Payment_Terms__c) sobjectFactory.createSObject(new Payment_Terms__c());
        insert newPaymentTerms;

        Product_Hierarchy__c newProductHierarchy = (Product_Hierarchy__c) sobjectFactory.createSObject(new Product_Hierarchy__c());
        insert newProductHierarchy;

		Product2 newProduct = (Product2)sobjectFactory.createSObject(new Product2(Product_Hierarchy__c = newProductHierarchy.Id, Production_Cost__c = 100));
		insert newProduct;

		Tax__c newTax = (Tax__c) sobjectFactory.createSObject(new Tax__c(Distribution_Center__c = newDC.Id, State__c = newState.Id, Product__c = newProduct.Id, Tax_On_Cost__c = 10));
        insert newTax;

        //CRIANDO DADOS PARA MARGEM
        Margin__c newMargin = (Margin__c) sobjectFactory.createSObject(new Margin__c(Distribution_Center__c = newDC.Id, Account__c = newAccount.Id, Product__c = newProduct.Id, City__c = newCity.Id, Value__c = 20));
        insert newMargin;

        //CRIANDO DADOS PARA FRETE
        Freight__c newFreight = (Freight__c) sobjectFactory.createSObject(new Freight__c(Distribution_Center__c = newDC.Id, City__c = newCity.Id, Product__c = newProduct.Id, Value__c = 100, Status__c = 'Aprovado'));
        insert newFreight;

        PricebookEntry pbe = [SELECT Pricebook2Id FROM PricebookEntry WHERE Product2Id = :newProduct.Id LIMIT 1];

		Order newOrder = (Order)sobjectFactory.createSObject(
			new Order(AccountId = newAccount.Id, Distribution_Center__c = newDC.Id, Payment_Terms__c = newPaymentTerms.Id, Address__c = newAccountAddress.Id, Pricebook2Id = pbe.Pricebook2Id, ExternalId__c = 'CalloutOrder')
		);
		Order newOrderError = (Order)sobjectFactory.createSObject(
			new Order(AccountId = newAccount.Id, Distribution_Center__c = newDC.Id, Payment_Terms__c = newPaymentTerms.Id, Address__c = newAccountAddress.Id, Pricebook2Id = pbe.Pricebook2Id, ExternalId__c = 'CalloutOrderError')
		);
		insert (new List<Order>{ newOrder, newOrderError });

		OrderItem newOrderItem = (OrderItem)sobjectFactory.createSObject(
			new OrderItem(OrderId = newOrder.Id, Product2Id = newProduct.Id, Quantity = 10, UnitPrice = 80, PricebookEntryId = pbe.Id)
		);
		OrderItem newOrderItem2 = (OrderItem)sobjectFactory.createSObject(
			new OrderItem(OrderId = newOrder.Id, Product2Id = newProduct.Id, Quantity = 10, UnitPrice = 80, PricebookEntryId = pbe.Id)
		);
		insert (new List<OrderItem>{ newOrderItem, newOrderItem2 });

		OrderItem newOrderItemError = (OrderItem)sobjectFactory.createSObject(
			new OrderItem(OrderId = newOrderError.Id, Product2Id = newProduct.Id, Quantity = 10, UnitPrice = 80, PricebookEntryId = pbe.Id)
		);
		OrderItem newOrderItemError2 = (OrderItem)sobjectFactory.createSObject(
			new OrderItem(OrderId = newOrderError.Id, Product2Id = newProduct.Id, Quantity = 10, UnitPrice = 80, PricebookEntryId = pbe.Id)
		);
		insert (new List<OrderItem>{ newOrderItemError, newOrderItemError2 });

		IntegrationSetting__c integration = (IntegrationSetting__c)sobjectFactory.createSObject(
			new IntegrationSetting__c(Name = 'IntegrationOutUsername')
		);
		insert integration;
	}

	@IsTest
	public static void processIntegrationTest() {
		List<String> orderIdList = new List<String>();
		for (Order order : [SELECT Id FROM Order LIMIT 2]) {
			orderIdList.add(order.Id);
		}

		Test.startTest();
			Test.setMock(
				HttpCalloutMock.class,
				new MockHttpResponse(true, TestUtility.getBodyResponse(), TestUtility.getBodyResponse())
			);
			CalloutOrder.executeCalloutOrder(orderIdList);
		Test.stopTest();
	}

	@IsTest
	public static void processIntegrationErrorTest() {
		List<String> orderIdList = new List<String>();
		Order updateOrder;
		for (Order order : [SELECT Id FROM Order LIMIT 2]) {
			orderIdList.add(order.Id);
			updateOrder = order;
		}

		Test.startTest();
			Test.setMock(
				HttpCalloutMock.class,
				new MockHttpResponse(false, TestUtility.getBodyResponse(), TestUtility.getBodyResponse())
			);
			update updateOrder;
			CalloutOrder.executeCalloutOrder(orderIdList);
		Test.stopTest();
	}

	@IsTest
	public static void processIntegrationExceptionTest() {
		List<String> orderIdList = new List<String>();
		for (Order order : [SELECT Id FROM Order LIMIT 2]) {
			orderIdList.add(order.Id);
		}

		Test.startTest();
			Test.setMock(
				HttpCalloutMock.class,
				new MockHttpResponse(true, TestUtility.getBodyResponseError(), TestUtility.getBodyResponseError())
			);
			CalloutOrder.executeCalloutOrder(orderIdList);
		Test.stopTest();
	}

	@IsTest
	public static void handlerAccessTokenTest() {
		Test.startTest();
			Test.setMock(
				HttpCalloutMock.class,
				new MockHttpResponse(true, TestUtility.getBodyAccessToken(), TestUtility.getBodyAccessToken())
			);

			CalloutOrder.handlerAccessToken(new CalloutOrder.AccessTokenLog());
		Test.stopTest();
	}

	@IsTest
	public static void getAccessTokenTest() {
		IntegrationSetting__c integrationSetting = getIntegrationSetting();
		integrationSetting.LastAccessTokenTime__c = null;
		update integrationSetting;

		Test.startTest();
			Test.setMock(
				HttpCalloutMock.class,
				new MockHttpResponse(true, TestUtility.getBodyAccessToken(), TestUtility.getBodyAccessToken())
			);
			CalloutOrder.handlerAccessToken(new CalloutOrder.AccessTokenLog());

			Test.setMock(
				HttpCalloutMock.class,
				new MockHttpResponse(false, TestUtility.getBodyAccessToken(), TestUtility.getBodyAccessToken())
			);
			try {
				CalloutOrder.handlerAccessToken(new CalloutOrder.AccessTokenLog());
			}
			catch (Exception ex) {}
		Test.stopTest();
	}

	@IsTest
	public static void treatmentMethodsTest() {
		CalloutOrder.callErrorTreatment();
		CalloutOrder.callSuccessTreatment();
	}

	@IsTest
	public static void updateIntegrationSettingTest() {
		IntegrationSetting__c currentIntegrationSetting = getIntegrationSetting();
		CalloutOrder.IntegrationSettings integrationSetting = new CalloutOrder.IntegrationSettings(currentIntegrationSetting);

		CalloutOrder.updateIntegrationSetting(integrationSetting);
	}

	public static IntegrationSetting__c getIntegrationSetting() {
		return [
			SELECT Id,
				   User__c,
				   Password__c,
				   ClientId__c,
				   ClientSecret__c,
				   Timeout__c,
				   AccessTokenTime__c,
				   LastAccessTokenTime__c,
				   EndpointAccessToken__c,
				   AccessToken__c,
				   Endpoint__c,
				   Method__c
			  FROM IntegrationSetting__c
			 LIMIT 1
		];
	}
}
