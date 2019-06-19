@IsTest
public class XAP_DAO_SOQL_SObjectFieldHelperTest {
	private static final XAP_DAO_SOQL_SObjectFieldHelper HELPER_UNDER_TEST = XAP_DAO_SOQL_SObjectFieldHelper.getInstance();
	@IsTest
	static void queryFieldsNotEquals() {
		String queryFactoryld = HELPER_UNDER_TEST.getFieldTokenPath(Contact.Name);
		String queryFactoryld2 = HELPER_UNDER_TEST.getFieldTokenPath(Contact.LastName);
		System.assert(!queryFactoryld.equals(queryFactoryld2));
	}

	@IsTest
	static void invalidFields_noQueryField() {
		try {
			HELPER_UNDER_TEST.getFieldTokenPath(null);
			System.assert(false, 'Expected InvalidFieldException; none was thrown');
		}
		catch (XAP_DAO_SOQL_InvalidFieldException ife) {
			//Expected
		}
		catch (Exception e) {
			System.assert(false, 'Expected InvalidFieldException; ' + e.getTypeName() + ' was thrown instead: ' + e);
		}
	}

}