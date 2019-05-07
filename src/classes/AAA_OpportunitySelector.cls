public virtual class AAA_OpportunitySelector extends AA0_SObjectSelectorAbs {
    AAA_OpportunityLineItemsSelector opportunityLineItemsSelector;
    AAA_PricebookEnrtrySelector pricebookEnrtrySelector;
    AAA_Pricebook2Selector pricebook2Selector;
    AAA_Product2Selector product2SelectorSelector;

    private AAA_OpportunitySelector(
            AAA_OpportunityLineItemsSelector opportunityLineItemsSelector,
            AAA_PricebookEnrtrySelector pricebookEnrtrySelector,
            AAA_Pricebook2Selector pricebook2Selector,
            AAA_Product2Selector product2SelectorSelector
    ) {
        this.opportunityLineItemsSelector = opportunityLineItemsSelector;
        this.pricebookEnrtrySelector = pricebookEnrtrySelector;
        this.pricebook2Selector = pricebook2Selector;
        this.product2SelectorSelector = product2SelectorSelector;
    }

    private AAA_OpportunitySelector() {
        this(
                AAA_OpportunityLineItemsSelector.getInstance(),
                AAA_PricebookEnrtrySelector.getInstance(),
                AAA_Pricebook2Selector.getInstance(),
                AAA_Product2Selector.getInstance()
        );
    }

    private static AAA_OpportunitySelector instance;

    public static AAA_OpportunitySelector getInstance() {
        if (instance == null) {
            instance = new AAA_OpportunitySelector();
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
        return (List<Opportunity>) Database.query(
                this.createQueryFactory(XAP_DAO_SOQL_SObjectSelectorAbs.EXCLUDE_SELECTOR_FIELDS)
                        .addField(Opportunity.Id)
                        .addField(Opportunity.Amount)
                        .addField(Opportunity.StageName)
                        .addField('Account.Name')
                        .addField('Account.AccountNumber')
                        .addField('Account.Owner.Name')
                        //.setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                        .setCondition('Id IN :idSet')
                        //.query();
                        .toSOQL()
        );
    }

    public List<Opportunity> selectByIdWithProducts(Set<Id> idSet) {
        AA0_QueryFactory opportunityQueryFactory = this.createQueryFactory();
        AA0_QueryFactory opportunityLineItemsQueryFactory = this.opportunityLineItemsSelector
                .injectParentFactoryFor(opportunityQueryFactory, 'OpportunityLineItems');

        this.pricebookEnrtrySelector
                .injectChildFactoryFor(opportunityLineItemsQueryFactory, 'PricebookEntry');

        this.pricebook2Selector
                .injectChildFactoryFor(opportunityLineItemsQueryFactory, 'PricebookEntry.Pricebook2');

        this.product2SelectorSelector
                .injectChildFactoryFor(opportunityLineItemsQueryFactory, 'PricebookEntry.Product2');

        return (List<Opportunity>) Database.query(
                opportunityQueryFactory
                        //.setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                        .setCondition('Id IN :idSet')
                        //.query();
                        .toSOQL()
        );
    }
}