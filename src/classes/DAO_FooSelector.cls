public virtual class DAO_FooSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_FooSelector() {
    }

    private static DAO_FooSelector instance;

    public static DAO_FooSelector getInstance() {
        if (instance == null) {
            instance = new DAO_FooSelector();
        }
        return instance;
    }

    public override SObjectType getSObjectType() {
        return Foo__c.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Foo__c.User__c
        };
    }

    public List<Foo__c> selectByCustomFields(
            Set<String> customField1Set,
            Set<String> customField2Set,
            Set<String> customField3Set
    ) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_AndClause(new List<XAP_DAO_SOQL_WHERE_ClauseIntf>{
                        new XAP_DAO_SOQL_WHERE_InStringSetClause(Foo__c.Custom_Field_1__c, customField1Set),
                        new XAP_DAO_SOQL_WHERE_InStringSetClause(Foo__c.Custom_Field_2__c, customField2Set),
                        new XAP_DAO_SOQL_WHERE_InStringSetClause(Foo__c.Custom_Field_3__c, customField3Set)
                }))
                .query();
    }
}