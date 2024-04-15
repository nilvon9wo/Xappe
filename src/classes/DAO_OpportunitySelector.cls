public virtual class DAO_OpportunitySelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private final DAO_OpportunityLineItemsSelector opportunityLineItemsSelector;
    private final DAO_PricebookEntrySelector pricebookEntrySelector;
    private final DAO_Pricebook2Selector pricebook2Selector;
    private final DAO_Product2Selector product2SelectorSelector;
    private final XAP_DAO_SOQL_AggregateResultMapConverter mapConverter;

    private DAO_OpportunitySelector(
            DAO_OpportunityLineItemsSelector opportunityLineItemsSelector,
            DAO_PricebookEntrySelector pricebookEntrySelector,
            DAO_Pricebook2Selector pricebook2Selector,
            DAO_Product2Selector product2SelectorSelector,
            XAP_DAO_SOQL_AggregateResultMapConverter mapConverter
    ) {
        this.opportunityLineItemsSelector = opportunityLineItemsSelector;
        this.pricebookEntrySelector = pricebookEntrySelector;
        this.pricebook2Selector = pricebook2Selector;
        this.product2SelectorSelector = product2SelectorSelector;
        this.mapConverter = mapConverter;
    }

    private DAO_OpportunitySelector() {
        this(
                DAO_OpportunityLineItemsSelector.getInstance(),
                DAO_PricebookEntrySelector.getInstance(),
                DAO_Pricebook2Selector.getInstance(),
                DAO_Product2Selector.getInstance(),
                XAP_DAO_SOQL_AggregateResultMapConverter.getInstance()
        );
    }

    private static DAO_OpportunitySelector instance;

    public static DAO_OpportunitySelector getInstance() {
        if (instance == null) {
            instance = new DAO_OpportunitySelector();
        }
        return instance;
    }

    public SObjectType getSObjectType() {
        return Opportunity.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Opportunity.Amount,
                Opportunity.Id,
                Opportunity.StageName
        };
    }

    //noinspection ApexUnusedDeclaration
    public List<Opportunity> selectByIdWithAccount(Set<Id> idSet) {
        return this.createQueryFactory(XAP_DAO_SOQL_SObjectSelectorAbs.EXCLUDE_SELECTOR_FIELDS)
                .addField(Opportunity.Id)
                .addField(Opportunity.Amount)
                .addField(Opportunity.StageName)
                .addField('Account.Name')
                .addField('Account.AccountNumber')
                .addField('Account.Owner.Name')
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
    }

    //noinspection ApexUnusedDeclaration
    public List<Opportunity> selectByIdWithProducts(Set<Id> idSet) {
        XAP_DAO_SOQL_QueryFactory opportunityQueryFactory = this.createQueryFactory();
        XAP_DAO_SOQL_QueryFactory opportunityLineItemsQueryFactory = this.opportunityLineItemsSelector
                .injectParentToSelectChildFields(opportunityQueryFactory, 'OpportunityLineItems');

        this.pricebookEntrySelector
                .injectChildToSelectParentFields(opportunityLineItemsQueryFactory, 'PricebookEntry');

        this.pricebook2Selector
                .injectChildToSelectParentFields(opportunityLineItemsQueryFactory, 'PricebookEntry.Pricebook2');

        this.product2SelectorSelector
                .injectChildToSelectParentFields(opportunityLineItemsQueryFactory, 'PricebookEntry.Product2');

        return opportunityQueryFactory
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
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