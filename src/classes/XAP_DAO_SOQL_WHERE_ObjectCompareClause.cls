public class XAP_DAO_SOQL_WHERE_ObjectCompareClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
    String fieldName;
    XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator;
    Object objectValue;

    public XAP_DAO_SOQL_WHERE_ObjectCompareClause(
            SObjectField sObjectField,
            XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator,
            Object objectValue
    ) {
        this.fieldName = XAP_DAO_SOQL_SObjectFieldHelper.getInstance().getFieldTokenPath(sObjectField);
        this.comparisonOperator = comparisonOperator;
        this.objectValue = objectValue;
    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        String comparisonOperator = XAP_DAO_SOQL_WHERE_CompareOpEnumHelper.get(this.comparisonOperator);
        String template = fieldName + comparisonOperator + ':${objectValue}';
        return new XAP_DAO_SOQL_QueryInterpolation(template, new Map<String, Object>{
                'objectValue' => this.objectValue
        });
    }
}