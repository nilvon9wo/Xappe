public virtual class AAA_Product2Selector extends AA0_SObjectSelectorAbs {
    public AAA_Product2Selector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
    }

    public AAA_Product2Selector() {
        super(XAP_DAO_SOQL_SObjectSelectorAbs.INCLUDE_FIELDSET_FIELDS);
    }

    public static AAA_Product2Selector getInstance() {
        return new AAA_Product2Selector();
    }

    public SObjectType getSObjectType() {
        return Product2.SObjectType;
    }

    public override List<FieldSet> getSObjectFieldSetList() {
        return new List<FieldSet>{
                SObjectType.Product2.fieldSets.getMap()
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

    public List<Product2> selectById(Set<Id> idSet, FieldSet fieldSet) {
        return (List<Product2>) Database.query(
                this.createQueryFactory()
                        .addFields(fieldSet)
                        //.setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(idSet))
                        .setCondition('Id IN :idSet')
                        //.query();
                        .toSOQL()
        );
    }

    public List<Product2> selectRecentlyUpdated(Integer recordLimit) {
        return (List<Product2>) Database.query(
                this.createQueryFactory()
                        .setCondition('SystemModstamp = LAST_N_DAYS:30')
//                        .setCondition(new XAP_DAO_SOQL_WHERE_StringCompareClause(
//                                Product2.SystemModstamp,
//                                XAP_DAO_SOQL_WHERE_CompareOperatorEnum.EQUALS,
//                                'LAST_N_DAYS:30'
//                        ))
                        .setLimit(recordLimit)
                        //.query();
                        .toSOQL()
        );
    }
}