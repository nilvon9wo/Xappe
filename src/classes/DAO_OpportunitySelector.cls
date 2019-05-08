public virtual class DAO_OpportunitySelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    DAO_OpportunityLineItemsSelector opportunityLineItemsSelector;
    DAO_PricebookEnrtrySelector pricebookEnrtrySelector;
    DAO_Pricebook2Selector pricebook2Selector;
    DAO_Product2Selector product2SelectorSelector;

    private DAO_OpportunitySelector(
            DAO_OpportunityLineItemsSelector opportunityLineItemsSelector,
            DAO_PricebookEnrtrySelector pricebookEnrtrySelector,
            DAO_Pricebook2Selector pricebook2Selector,
            DAO_Product2Selector product2SelectorSelector
    ) {
        this.opportunityLineItemsSelector = opportunityLineItemsSelector;
        this.pricebookEnrtrySelector = pricebookEnrtrySelector;
        this.pricebook2Selector = pricebook2Selector;
        this.product2SelectorSelector = product2SelectorSelector;
    }

    private DAO_OpportunitySelector() {
        this(
                DAO_OpportunityLineItemsSelector.getInstance(),
                DAO_PricebookEnrtrySelector.getInstance(),
                DAO_Pricebook2Selector.getInstance(),
                DAO_Product2Selector.getInstance()
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

    public List<Opportunity> selectByIdWithProducts(Set<Id> idSet) {
        XAP_DAO_SOQL_QueryFactory opportunityQueryFactory = this.createQueryFactory();
        XAP_DAO_SOQL_QueryFactory opportunityLineItemsQueryFactory = this.opportunityLineItemsSelector
                .injectParentFactory(opportunityQueryFactory, 'OpportunityLineItems');

        this.pricebookEnrtrySelector
                .injectChildFactory(opportunityLineItemsQueryFactory, 'PricebookEntry');

        this.pricebook2Selector
                .injectChildFactory(opportunityLineItemsQueryFactory, 'PricebookEntry.Pricebook2');

        this.product2SelectorSelector
                .injectChildFactory(opportunityLineItemsQueryFactory, 'PricebookEntry.Product2');

        return opportunityQueryFactory
                .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                .query();
    }
}