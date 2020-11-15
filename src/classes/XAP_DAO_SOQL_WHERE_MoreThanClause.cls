public with sharing class XAP_DAO_SOQL_WHERE_MoreThanClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
    String fieldName;
    Integer quantity;

    public XAP_DAO_SOQL_WHERE_MoreThanClause(
            SObjectField sObjectField,
            Integer quantity
    ) {
        this.fieldName = XAP_DAO_SOQL_SObjectFieldHelper.getInstance().getFieldTokenPath(sObjectField);
        this.quantity = quantity;
    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        return new XAP_DAO_SOQL_QueryInterpolation(fieldName + '> :${objectValue}', new Map<String, Object>{
                'objectValue' => this.quantity
        });
    }
}