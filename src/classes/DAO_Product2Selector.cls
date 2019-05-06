public virtual class DAO_Product2Selector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private DAO_Product2Selector() {
    }

    private static DAO_Product2Selector instance;

    public static DAO_Product2Selector getInstance() {
        if (instance == null) {
            instance = new DAO_Product2Selector();
        }
        return instance;
    }

    public override SObjectType getSObjectType() {
        return Product2.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                Product2.Description,
                Product2.Id,
                Product2.IsActive,
                Product2.Name,
                Product2.ProductCode
        };
    }

    public List<Product2> selectRecentlyUpdated(Integer recordLimit) {
        return this.newQueryFactory()
                .setCondition(new XAP_DAO_SOQL_WHERE_StringCompareClause(
                        Product2.SystemModstamp,
                        XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS,
                        'LAST_N_DAYS:30'
                ))
                .setLimit(recordLimit)
                .query();
    }
}
