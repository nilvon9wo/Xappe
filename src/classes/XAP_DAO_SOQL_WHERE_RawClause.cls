public with sharing class XAP_DAO_SOQL_WHERE_RawClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
    String whereClause;

    public XAP_DAO_SOQL_WHERE_RawClause(String whereClause) {
        this.whereClause = whereClause;
    }

    public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
        return new XAP_DAO_SOQL_QueryInterpolation(whereClause);
    }
}