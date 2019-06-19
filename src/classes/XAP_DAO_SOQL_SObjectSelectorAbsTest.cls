/**
 * Inspired by and derived from FinancialForce.com's Apex Commons.
 * @see: https://github.com/financialforcedev/fflib-apex-common/blob/master/fflib/src/classes/fflib_SObjectSelectorTest.cls
 */
@IsTest
public with sharing class XAP_DAO_SOQL_SObjectSelectorAbsTest {

	@IsTest public static void testGetSObjectName() {
		TestSObjectSelector selector = new TestSObjectSelector();
		System.assertEquals(null, selector.getSObjectFieldSetList());
		System.assertEquals('Account', selector.getSObjectName());
	}

	@IsTest public static void testSelectSObjectsById() {
		// Inserting in reverse order so that we can test the order by of select
		List<Account> accountList = new List<Account>{
				new Account(Name = 'TestAccount2', AccountNumber = 'A2', AnnualRevenue = 12345.67),
				new Account(Name = 'TestAccount1', AccountNumber = 'A1', AnnualRevenue = 76543.21)
		};
		insert accountList;
		Set<Id> idSet = new Set<Id>();
		for (Account item : accountList) {
			idSet.add(item.Id);
		}

		Test.startTest();
		TestSObjectSelector selector = new TestSObjectSelector();
		List<Account> result = (List<Account>) selector.selectById(idSet);
		Test.stopTest();

		System.assertEquals(2, result.size());
		System.assertEquals('TestAccount2', result[0].Name);
		System.assertEquals('A2', result[0].AccountNumber);
		System.assertEquals(12345.67, result[0].AnnualRevenue);
		System.assertEquals('TestAccount1', result[1].Name);
		System.assertEquals('A1', result[1].AccountNumber);
		System.assertEquals(76543.21, result[1].AnnualRevenue);
	}

	@IsTest public static void testQueryLocatorById() {
		// Inserting in reverse order so that we can test the order by of select
		List<Account> accountList = new List<Account>{
				new Account(Name = 'TestAccount2', AccountNumber = 'A2', AnnualRevenue = 12345.67),
				new Account(Name = 'TestAccount1', AccountNumber = 'A1', AnnualRevenue = 76543.21)
		};
		insert accountList;
		Set<Id> idSet = new Set<Id>();
		for (Account item : accountList) {
			idSet.add(item.Id);
		}

		Test.startTest();
		TestSObjectSelector selector = new TestSObjectSelector();
		Database.QueryLocator result = selector.getQueryLocatorById(idSet);
		System.Iterator<SObject> iteratorResult = result.iterator();
		Test.stopTest();

		System.assert(true, iteratorResult.hasNext());
		Account account = (Account) iteratorResult.next();
		System.assertEquals('TestAccount2', account.Name);
		System.assertEquals('A2', account.AccountNumber);
		System.assertEquals(12345.67, account.AnnualRevenue);
		System.assert(true, iteratorResult.hasNext());
		account = (Account) iteratorResult.next();
		System.assertEquals('TestAccount1', account.Name);
		System.assertEquals('A1', account.AccountNumber);
		System.assertEquals(76543.21, account.AnnualRevenue);
		System.assertEquals(false, iteratorResult.hasNext());
	}

	@IsTest public static void testAssertIsAccessible() {
		List<Account> accountList = new List<Account>{
				new Account(Name = 'TestAccount2', AccountNumber = 'A2', AnnualRevenue = 12345.67),
				new Account(Name = 'TestAccount1', AccountNumber = 'A1', AnnualRevenue = 76543.21)
		};
		insert accountList;

		Set<Id> idSet = new Set<Id>();
		for (Account account : accountList) {
			idSet.add(account.Id);
		}

		// Create a user which will not have access to the test object type
		User testUser = createChatterExternalUser();

		if (testUser == null) {
			return; // Abort the test if unable to create a user with low enough acess
		}

		System.runAs(testUser) {
			TestSObjectSelector selector = new TestSObjectSelector();
			try {
				selector.selectById(idSet);
				System.assert(false, 'Expected exception was not thrown');
			}
			catch (XAP_DAO_SOQL_DomainSecurityException e) {
				System.assertEquals('Permission to access an Account denied.', e.getMessage());
			}
		}
	}

	@IsTest public static void testCRUDOff() {
		List<Account> accountList = new List<Account>{
				new Account(Name = 'TestAccount2', AccountNumber = 'A2', AnnualRevenue = 12345.67),
				new Account(Name = 'TestAccount1', AccountNumber = 'A1', AnnualRevenue = 76543.21)
		};
		insert accountList;
		Set<Id> idSet = new Set<Id>();
		for (Account item : accountList) {
			idSet.add(item.Id);
		}

		// Create a user which will not have access to the test object type
		User testUser = createChatterExternalUser();
		if (testUser == null) {
			return;
		} // Abort the test if unable to create a user with low enough acess
		System.runAs(testUser) {
			TestSObjectSelector selector = new TestSObjectSelector(false, false, false, true);
			try {
				selector.selectById(idSet);
			}
			catch (XAP_DAO_SOQL_DomainSecurityException e) {
				System.assert(false, 'Did not expect an exception to be thrown');
			}
		}
	}

	@IsTest public static void testSOQL() {
		TestSObjectSelector selector = new TestSObjectSelector();
		String soql = selector.createQueryFactory().toSOQL();
		Pattern p = Pattern.compile(
				'SELECT (.*) FROM Account ORDER BY Name DESC NULLS FIRST , AnnualRevenue ASC NULLS LAST '
		);
		Matcher m = p.matcher(soql);
		System.assert(
				m.matches(), 'Generated SOQL does not match expected pattern. Here is the generated SOQL: ' + soql
		);
		System.assertEquals(1, m.groupCount(), 'Unexpected number of groups captured.');
		String fieldListString = m.group(1);
		assertFieldListString(fieldListString, null);
	}

	@IsTest public static void testDefaultConfig() {
		TestSObjectSelector selector = new TestSObjectSelector();
		System.assertEquals(false, selector.isEnforcingFLS());
		System.assertEquals(true, selector.isEnforcingCRUD());
		System.assertEquals(false, selector.isIncludeFieldSetFields());

		System.assertEquals('Account', selector.getSObjectName());
		System.assertEquals(Account.SObjectType, selector.getSObjectType());
	}

	private static void assertFieldListString(String fieldListString, String prefix) {
		String prefixString = (!String.isBlank(prefix)) ? prefix + '.' : '';
		List<String> fieldList = fieldListString.split(',{1}\\s?');
		System.assertEquals(UserInfo.isMultiCurrencyOrganization() ? 5 : 4, fieldList.size());
		Set<String> fieldSet = new Set<String>();
		fieldSet.addAll(fieldList);
		String expected = prefixString + 'AccountNumber';
		System.assert(fieldSet.contains(expected), expected + ' missing from field list string: ' + fieldListString);
		expected = prefixString + 'AnnualRevenue';
		System.assert(fieldSet.contains(expected), expected + ' missing from field list string: ' + fieldListString);
		expected = prefixString + 'Id';
		System.assert(fieldSet.contains(expected), expected + ' missing from field list string: ' + fieldListString);
		expected = prefixString + 'Name';
		System.assert(fieldSet.contains(expected), expected + ' missing from field list string: ' + fieldListString);
		if (UserInfo.isMultiCurrencyOrganization()) {
			expected = prefixString + 'CurrencyIsoCode';
			System.assert(fieldSet.contains(expected), expected + ' missing from field list string: ' + fieldListString);
		}
	}

	@IsTest
	static void testWithoutSorting() {
		//Given
		TestSObjectSelector selector = new TestSObjectSelector(false, false, false, false);
		XAP_DAO_SOQL_QueryFactory queryFactory = selector.createQueryFactory();

		Set<String> expectedSelectFields = new Set<String>{
				'Name', 'Id', 'AccountNumber', 'AnnualRevenue'
		};
		if (UserInfo.isMultiCurrencyOrganization()) {
			expectedSelectFields.add('CurrencyIsoCode');
		}

		//When
		String soql = queryFactory.toSOQL();

		//Then
		Pattern soqlPattern = Pattern.compile(
				'SELECT (.*) FROM Account ORDER BY Name DESC NULLS FIRST , AnnualRevenue ASC NULLS LAST '
		);
		Matcher soqlMatcher = soqlPattern.matcher(soql);
		soqlMatcher.matches();
		List<String> actualSelectFields = soqlMatcher.group(1).deleteWhitespace().split(',');
		System.assertEquals(expectedSelectFields, new Set<String>(actualSelectFields));
	}

	// Test case of ordering with NULLS LAST option passed into the ordering method
	@IsTest
	static void testWithOrderingNullsLast() {
		// Build the selector to test with
		TestSObjectSelector selector = new TestSObjectSelector(false, false, false, false);
		XAP_DAO_SOQL_QueryFactory queryFactory = selector.createQueryFactory();

		// Add in the expected fields
		Set<String> expectedSelectFields = new Set<String>{
				'Name', 'Id', 'AccountNumber', 'AnnualRevenue'
		};
		if (UserInfo.isMultiCurrencyOrganization()) {
			expectedSelectFields.add('CurrencyIsoCode');
		}

		// Generate the SOQL string
		String soql = queryFactory.toSOQL();

		// Assert that the
		Pattern soqlPattern = Pattern.compile(
				'SELECT (.*) FROM Account ORDER BY Name DESC NULLS FIRST , AnnualRevenue ASC NULLS LAST '
		);
		Matcher soqlMatcher = soqlPattern.matcher(soql);
		System.assert(soqlMatcher.matches(), 'The SOQL should have that expected.');
	}

	private class TestSObjectSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
		public TestSObjectSelector() {
			super();
		}

		public TestSObjectSelector(
				Boolean includeFieldSetFields,
				Boolean enforceCRUD,
				Boolean enforceFLS,
				Boolean sortSelectFields
		) {
			super(includeFieldSetFields, enforceCRUD, enforceFLS, sortSelectFields);
		}

		public List<SObjectField> getSObjectFieldList() {
			return new List<SObjectField>{
					Account.Name,
					Account.Id,
					Account.AccountNumber,
					Account.AnnualRevenue
			};
		}

		public SObjectType getSObjectType() {
			return Account.SObjectType;
		}

		public override String getOrderBy() {
			return 'Name DESC, AnnualRevenue ASC NULLS LAST';
		}
	}

	/**
	 * Create test user
	 **/
	private static User createChatterExternalUser() {
		// Can only proceed with test if we have a suitable profile - Chatter External license has no access to Opportunity
		List<Profile> testProfiles = [SELECT Id FROM Profile WHERE UserLicense.Name = 'Chatter External' LIMIT 1];
		if (testProfiles.size() != 1) {
			return null;
		}

		// Can only proceed with test if we can successfully insert a test user
		String testUsername = System.now().format('yyyyMMddhhmmss') + '@testorg.com';
		User testUser = new User(
				Alias = 'test1',
				Email = 'testuser1@testorg.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Testing',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				ProfileId = testProfiles[0].Id,
				TimeZoneSidKey = 'America/Los_Angeles',
				Username = testUsername
		);
		try {
			insert testUser;
		}
		catch (Exception e) {
			return null;
		}
		return testUser;
	}
}