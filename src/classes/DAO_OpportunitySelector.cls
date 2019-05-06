public virtual class DAO_OpportunitySelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_OpportunitySelector() {
    }

    private static DAO_OpportunitySelector instance;

    public static DAO_OpportunitySelector getInstance() {
        if (instance == null) {
            instance = new DAO_OpportunitySelector();
        }
        return instance;
    }

    public override SObjectType getSObjectType() {
        return Opportunity.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Opportunity.Id
        };
    }
}
