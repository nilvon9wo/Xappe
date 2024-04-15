public class DAO_PricebookEntrySelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
	private DAO_PricebookEntrySelector() {
	}

	private static DAO_PricebookEntrySelector instance;

	public static DAO_PricebookEntrySelector getInstance() {
		if (instance == null) {
			instance = new DAO_PricebookEntrySelector();
		}
		return instance;
	}

	public SObjectType getSObjectType() {
		return PricebookEntry.SObjectType;
	}

	private List<SObjectField> getSObjectFieldList() {
		return new List<SObjectField>{
				PricebookEntry.Id
		};
	}
}