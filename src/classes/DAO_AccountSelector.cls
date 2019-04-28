public virtual class DAO_AccountSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_AccountSelector() {
    }

    private static DAO_AccountSelector INSTANCE;

    public static DAO_AccountSelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new DAO_AccountSelector();
        }
        return INSTANCE;
    }

    public override SObjectType getSObjectType() {
        return Account.SObjectType;
    }

    private List<Schema.SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Account.Id,
                Account.Name,
                Account.BillingState
        };
    }

    public List<Account> selectByBillingState(Set<String> stateSet) {
        return (List<Account>) Database.query(
                this.newQueryFactory()
                        .setCondition(new XAP_DAO_SOQL_WHERE_InStringSetClause(
                                Account.BillingState,
                                stateSet
                        ))
                        .toSOQL()
        );
    }
}