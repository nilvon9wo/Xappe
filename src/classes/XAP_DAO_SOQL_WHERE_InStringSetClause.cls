public class XAP_DAO_SOQL_WHERE_InStringSetClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
    String fieldName;
    Set<String> stringSet;

    public XAP_DAO_SOQL_WHERE_InStringSetClause(SObjectField sObjectField, Set<String> stringSet) {
        this.fieldName = XAP_DAO_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
        this.stringSet = stringSet;
    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        String template = fieldName + ' IN  ${stringSet}';
        return new XAP_DAO_SOQL_QueryInterpolation(template, new Map<String, Object>{
                'stringSet' => this.stringSet
        });
    }
}

