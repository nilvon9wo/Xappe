public virtual class DAO_Product2Selector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    public DAO_Product2Selector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
    }

    public DAO_Product2Selector() {
        super(XAP_DAO_SOQL_SObjectSelectorAbs.INCLUDE_FIELDSET_FIELDS);
    }

    public static DAO_Product2Selector getInstance() {
        return new DAO_Product2Selector();
    }

    public override SObjectType getSObjectType() {
        return Product2.SObjectType;
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet>{
                SObjectType.Product2.FieldSets.getMap()
                        .get('example_field_set')
        };
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
