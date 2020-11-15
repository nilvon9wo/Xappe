public with sharing class XAP_DAO_SOQL_WHERE_True implements XAP_DAO_SOQL_WHERE_ClauseIntf {
    String fieldName;

    public XAP_DAO_SOQL_WHERE_True(SObjectField sObjectField) {
        this.fieldName = XAP_DAO_SOQL_SObjectFieldHelper.getInstance()
                .getFieldTokenPath(sObjectField);
    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        return new XAP_DAO_SOQL_QueryInterpolation(this.fieldName + ' = TRUE ');
    }
}