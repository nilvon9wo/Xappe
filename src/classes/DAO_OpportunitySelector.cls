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
                Opportunity.Amount,
                Opportunity.Id,
                Opportunity.StageName
        };
    }

    public List<Opportunity> selectWithAccountById(Set<Id> idSet) {
        return this.newQueryFactory(XAP_DAO_SOQL_SObjectSelectorAbs.EXCLUDE_SELECTOR_FIELDS)
                .selectField(Opportunity.Id)
                .selectField(Opportunity.Amount)
                .selectField(Opportunity.StageName)
                .selectField('Account.Name')
                .selectField('Account.AccountNumber')
                .selectField('Account.Owner.Name')
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
    }
}
