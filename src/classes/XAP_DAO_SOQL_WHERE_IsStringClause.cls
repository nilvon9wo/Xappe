public class XAP_DAO_SOQL_WHERE_IsStringClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
    String fieldName;
    String targetValue;

    public XAP_DAO_SOQL_WHERE_IsStringClause(SObjectField sObjectField, String targetValue) {
        this.fieldName = XAP_DAO_SOQL_SObjectFieldHelper.getInstance().getFieldTokenPath(sObjectField);
        this.targetValue = targetValue;
    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        String template = fieldName + ' = :${targetValue}';

        return new XAP_DAO_SOQL_QueryInterpolation(template, new Map<String, Object>{
                'targetValue' => this.targetValue
        });
    }
}