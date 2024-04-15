public virtual with sharing class DAO_OpportunitySelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private final XAP_DAO_SOQL_AggregateResultMapConverter mapConverter;
    private DAO_OpportunitySelector(XAP_DAO_SOQL_AggregateResultMapConverter mapConverter) {
        this.mapConverter = mapConverter;
    }

    private DAO_OpportunitySelector() {
        this(XAP_DAO_SOQL_AggregateResultMapConverter.getInstance());
    }

    private static DAO_OpportunitySelector INSTANCE;
    public static DAO_OpportunitySelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new DAO_OpportunitySelector();
        }
        return INSTANCE;
    }

    public SObjectType getSObjectType() {
        return Contact.SObjectType;
    }

    protected List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>();
    }

    //noinspection ApexUnusedDeclaration
    public Decimal getAverageAmount() {
        AggregateResult[] results = [
                SELECT AVG(Amount) average
                FROM Opportunity
        ];

        return (Decimal) results[0].get('average');
    }

    //noinspection ApexUnusedDeclaration
    public Map<Id, Decimal> getAverageAmountByCampaignId() {
        AggregateResult[] results = [
                SELECT CampaignId, AVG(Amount) average
                FROM Opportunity
                GROUP BY CampaignId
        ];

        return this.mapConverter.convertToDecimalById(results, Opportunity.CampaignId, 'average');
    }
}