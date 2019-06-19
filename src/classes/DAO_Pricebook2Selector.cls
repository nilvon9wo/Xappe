public class DAO_Pricebook2Selector extends XAP_DAO_SOQL_SObjectSelectorAbs {
	private DAO_Pricebook2Selector() {
	}

	private static DAO_Pricebook2Selector instance;

	public static DAO_Pricebook2Selector getInstance() {
		if (instance == null) {
			instance = new DAO_Pricebook2Selector();
		}
		return instance;
	}

	public SObjectType getSObjectType() {
		return Pricebook2.SObjectType;
	}

	private List<SObjectField> getSObjectFieldList() {
		return new List<SObjectField>{
				Pricebook2.Id
		};
	}
}