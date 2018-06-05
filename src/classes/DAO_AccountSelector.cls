public class DAO_AccountSelector extends XAP_DAO_SObjectSelectorAbs {
	private DAO_AccountSelector() {
	}

	private static DAO_AccountSelector INSTANCE;
	
	public static DAO_AccountSelector getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new DAO_AccountSelector();
		}
		return INSTANCE; 
	}

	private static final List<SObjectField>  SELECTOR_SOBJECT_FIELD_LIST = new List<SObjectField> {
		Account.Id,
		Account.Name,
		Account.BillingState
	}; 

    public override SObjectType getSObjectType() {
    	return Account.SObjectType;
    }  
    
	List<Schema.SObjectField> getSObjectFieldList() {
		return SELECTOR_SOBJECT_FIELD_LIST;
	} 

    public List<Account> selectByBillingState(Set<String> stateSet) {
		return (List<Account>) Database.query(
			this.newQueryFactory()
				.setCondition(new XAP_DAO_WHERE_BindingComparisonClause(
					Account.BillingState,
					XAP_DAO_WHERE_ComparisonOperatorEnum.IS_IN,
					'stateSet'
				))
				.toSOQL() 
		);
    }
}