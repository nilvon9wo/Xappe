public class XAP_DAO_SOQL_WHERE_DateComparisonClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
    String fieldName;
    XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator;
    Date dateValue;

    public XAP_DAO_SOQL_WHERE_DateComparisonClause(
            SObjectField sObjectField,
            XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator,
            Date dateValue
    ) {
        this.fieldName = XAP_DAO_SOQL_SObjectFieldHelper.getInstance().getFieldTokenPath(sObjectField);
        this.comparisonOperator = comparisonOperator;
        this.dateValue = dateValue;
    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        String comparisonOperator = XAP_DAO_SOQL_WHERE_CompareOpEnumHelper.get(this.comparisonOperator);
        String template = fieldName + comparisonOperator + ':${dateValue}';
        return new XAP_DAO_SOQL_QueryInterpolation(template, new Map<String, Object>{
                'dateValue' => this.dateValue
        });
    }
}