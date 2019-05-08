public class XAP_DAO_SOQL_WHERE_StringCompareClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
    String fieldName;
    XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator;
    String stringValue;

    public XAP_DAO_SOQL_WHERE_StringCompareClause(
            String fieldName,
            XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator,
            String stringValue
    ) {
        this.fieldName = fieldName;
        this.comparisonOperator = comparisonOperator;
        this.stringValue = stringValue;
    }

    public XAP_DAO_SOQL_WHERE_StringCompareClause(
            SObjectField sObjectField,
            XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator,
            String stringValue
    ) {
        this(
                XAP_DAO_SOQL_SObjectFieldHelper.getInstance().getFieldTokenPath(sObjectField),
                comparisonOperator,
                stringValue
        );

    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        String comparisonOperator = XAP_DAO_SOQL_WHERE_CompareOpEnumHelper.get(this.comparisonOperator);
        String template = fieldName + ' ' + comparisonOperator + ' ' + this.stringValue;
        return new XAP_DAO_SOQL_QueryInterpolation(template, new Map<String, Object>{
        });
    }
}