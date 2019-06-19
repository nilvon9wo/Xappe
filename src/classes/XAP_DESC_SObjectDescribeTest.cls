@IsTest
private class XAP_DESC_SObjectDescribeTest {

	@IsTest
	static void getDescribe_badInput() {
		String nullStr = null; //having it as a string var makes for unambiguous selection of overloads
		SObjectType nullType = null;
		DescribeSObjectResult nullDescribe = null;
		SObject nullSObject = null;
		System.assertEquals(null, XAP_DESC_SObjectDescribe.getDescribe(nullStr));
		System.assertEquals(null, XAP_DESC_SObjectDescribe.getDescribe(''));
		System.assertEquals(null, XAP_DESC_SObjectDescribe.getDescribe(' '));
		System.assertEquals(null, XAP_DESC_SObjectDescribe.getDescribe(nullType));
		System.assertEquals(null, XAP_DESC_SObjectDescribe.getDescribe(nullDescribe));
		System.assertEquals(null, XAP_DESC_SObjectDescribe.getDescribe(nullSObject));
	}

	@IsTest
	static void NamespacedAttributeMap_implementations() {
		XAP_DESC_GlobalDescribeMap gdm = XAP_DESC_SObjectDescribe.WRAPPED_GLOBAL_DESCRIBE;
		SObjectType accountObjType = gdm.get('AccOunT');
		System.assertEquals(accountObjType, Account.SObjectType);
		//FIXME: System.assertEquals(Schema.getGlobalDescribe().size(), gdm.size());

		XAP_DESC_SObjectDescribe acccountDescribe = XAP_DESC_SObjectDescribe.getDescribe(accountObjType);
		Map<String, SObjectField> fields = acccountDescribe.getFieldsMap();
		System.assert(fields.keySet().containsAll(acccountDescribe.getFieldsMap().keySet()));

		System.assertEquals(fields.get('name'), Account.SObjectType.fields.Name); //behavior of FieldsMap is tested in another method
		System.assertEquals(SObjectType.Account.fields.getMap().size(), fields.size());

		System.assertEquals(null, fields.get(null), 'Null input should result in null ouput.');
		System.assertEquals(null, fields.get(''), 'Invalid fieldname input should result in null ouput.');
	}

	@IsTest
	static void FieldsMap() {
		String fakeNamespace = 'fflib_test';
		Map<String, SObjectField> fakeFieldData = new Map<String, SObjectField>{
				'name__c' => Contact.SObjectType.fields.Name, //re-use standard field types since we can't mock them
				fakeNamespace + '__name__c' => Account.SObjectType.fields.Name,
				fakeNamespace + '__otherField__c' => Account.SObjectType.fields.Name,
				'createddate' => Contact.SObjectType.fields.CreatedDate
		};
		XAP_DESC_FieldsMap fields = new XAP_DESC_FieldsMap(fakeFieldData);
		fields.currentNamespace = fakeNamespace;
		System.assertEquals(true, fields.containsKey('name__c'));
		System.assertEquals(true, fields.containsKey(fakeNamespace.toUpperCase() + '__nAMe__c'));
		System.assert(fields.get('NAme__c') === fields.get(fakeNamespace + '__namE__c'));

		System.assert(!fields.keySet(false).contains('otherField__c'));
		System.assert(fields.keySet(false).contains(fakeNamespace + '__otherField__c'));

		System.assert(fields.keySet(true).contains('otherField__c'));
		System.assert(!fields.keySet(true).contains(fakeNamespace + '__otherField__c'));

		fields.currentNamespace = 'someOtherNamespace';
		System.assertNotEquals(fields.get('name__C'), fields.get(fakeNamespace.capitalize() + '__nAme__c'));
	}

	@IsTest
	static void GlobalDescribeMap() {
		String fakeNamespace = 'fflib_test';
		Map<String, SObjectType> fakeFieldData = new Map<String, SObjectType>{
				'name__c' => Contact.SObjectType, //re-use stndard object types since we can't mock them
				fakeNamespace + '__name__c' => Account.SObjectType,
				'createddate' => Lead.SObjectType
		};
		XAP_DESC_GlobalDescribeMap gdm = new XAP_DESC_GlobalDescribeMap(fakeFieldData);
		gdm.currentNamespace = fakeNamespace;
		System.assertEquals(true, gdm.containsKey('name__c'));
		System.assertEquals(true, gdm.containsKey(fakeNamespace + '__name__c'));
		System.assert(gdm.get('name__c') === gdm.get(fakeNamespace + '__name__c'));

		gdm.currentNamespace = 'someOtherNamespace';
		System.assertNotEquals(gdm.get('name__c'), gdm.get(fakeNamespace + '__name__c'));
	}

	@IsTest //Tests all forms of the getDescribe static
	static void getAccountDescribes() {
		XAP_DESC_SObjectDescribe d = XAP_DESC_SObjectDescribe.getDescribe('Account');
		XAP_DESC_SObjectDescribe d2 = XAP_DESC_SObjectDescribe.getDescribe(Account.SObjectType);
		XAP_DESC_SObjectDescribe d3 = XAP_DESC_SObjectDescribe.getDescribe(SObjectType.Account);
		System.assertEquals('Account', d.getDescribe().getName());
		System.assert((d === d2 && d2 === d3), 'All three getDescribe calls should return the same cached instance.');
	}

	@IsTest
	static void simpleAccountFieldDescribe() {
		XAP_DESC_SObjectDescribe sObjectDescribe = XAP_DESC_SObjectDescribe.getDescribe(Account.SObjectType);
		Map<String, SObjectField> fields;
		for (Integer i = 0; i < 10; i++) {
			fields = sObjectDescribe.getFieldsMap();
		}

		System.assertEquals(false, fields.isEmpty());
		System.assertEquals(Account.SObjectType, sObjectDescribe.sObjectType);
	}

	@IsTest
	static void simpleAccountGetNameField() {
		XAP_DESC_SObjectDescribe d = XAP_DESC_SObjectDescribe.getDescribe(Account.SObjectType);
		SObjectField nameField = d.getNameField();
		System.assertEquals('Name', nameField.getDescribe().getName());
	}

	@IsTest
	static void rawGlobalDescribeCheck() {
		Map<String, SObjectType> systemGd = Schema.getGlobalDescribe();
		Map<String, SObjectType> cachedGd = XAP_DESC_SObjectDescribe.RAW_GLOBAL_DESCRIBE;
		//FIXME: System.assertEquals(systemGd.size(), cachedGd.size());
	}

}