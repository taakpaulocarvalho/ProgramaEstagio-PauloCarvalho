@IsTest
public with sharing class IntegrationInboundOrderTest {
	@TestSetup
	public static void makeData() {
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

		 //CRIANDO DADOS PARA IMPOSTO
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
	}

	@IsTest
	public static void upsertOrderTest() {
		List<DataIntegrationFields.OrderINData> orderRequestList = fillOrderINDataList();

		Test.startTest();
			IntegrationInboundOrder.doPost(orderRequestList);
		Test.stopTest();
	}

	@IsTest
	public static void upsertOrderExceptionTest() {
		RestContext.response = new RestResponse();

		Test.startTest();
			IntegrationInboundOrder.doPost(null);
		Test.stopTest();
	}

	@IsTest
	public static void updateOrderWithIntegrationLogId() {
		Order currentOrder = getOrder();

		Test.startTest();
			IntegrationInboundOrder.updateOrderWithIntegrationLogId(
				new List<Order>{ currentOrder },
				null,
				'IN'
			);
			IntegrationInboundOrder.updateOrderWithIntegrationLogId(
				new List<Order>{ currentOrder },
				null,
				'OUT'
			);

			IntegrationInboundOrder.updateOrderWithIntegrationLogId(null, null, null);
		Test.stopTest();
	}

	public static List<DataIntegrationFields.OrderINData> fillOrderINDataList() {
		List<Order> orderList = [SELECT Id, ExternalId__c, EffectiveDate, Status, Account.ExternalId__c, Pricebook2.ExternalId__c FROM Order LIMIT 2];

		DataIntegrationFields.OrderINData orderINData = fillOrderINData(orderList[0]);
		DataIntegrationFields.OrderINData orderINDataError = fillOrderINData(orderList[1]);
		orderINDataError.id = orderList[1].Id;
		orderINDataError.externalId = null;

		return new List<DataIntegrationFields.OrderINData>{ orderINData, orderINDataError };
	}

	public static DataIntegrationFields.OrderINData fillOrderINData(Order order) {
		DataIntegrationFields.OrderINData orderINData = new DataIntegrationFields.OrderINData();

		orderINData.externalId = order.ExternalId__c;
		orderINData.status = order.Status;
		orderINData.effectiveDate = order.EffectiveDate;
		orderINData.accountExternalId = order.Account.ExternalId__c;
		orderINData.pricebook2ExternalId = order.Pricebook2.ExternalId__c;
		orderINData.orderItemList = fillOrderItemINDataList(order.Id);

		return orderINData;
	}

	public static List<DataIntegrationFields.OrderItemINData> fillOrderItemINDataList(String orderId) {
		OrderItem orderItem = 	[
									SELECT Id, ExternalId__c, Quantity, UnitPrice, Order.ExternalId__c, Product2.ExternalId__c, PricebookEntry.ExternalId__c
									FROM OrderItem
									WHERE OrderId =: orderId
									LIMIT 1
								];

		return new List<DataIntegrationFields.OrderItemINData>{ fillOrderItemINData(orderItem) };
	}

	public static DataIntegrationFields.OrderItemINData fillOrderItemINData(OrderItem orderItem) {
		DataIntegrationFields.OrderItemINData orderItemINData = new DataIntegrationFields.OrderItemINData();

		orderItemINData.externalId = orderItem.ExternalId__c;
		orderItemINData.quantity = orderItem.Quantity;
		orderItemINData.unitPrice = orderItem.UnitPrice;
		orderItemINData.orderExternalId = orderItem.Order.ExternalId__c;
		orderItemINData.productExternalId = orderItem.Product2.ExternalId__c;
		orderItemINData.pricebookEntryExternalId = orderItem.PricebookEntry.ExternalId__c;

		return orderItemINData;
	}

	public static Order getOrder() {
		Order currentOrder;

		for (Order retrievedOrder : [
			SELECT Id
			  FROM Order
			 LIMIT 1
		]) {
			currentOrder = retrievedOrder;
		}

		return currentOrder;
	}
}
