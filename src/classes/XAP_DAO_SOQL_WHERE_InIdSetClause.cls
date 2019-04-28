public class XAP_DAO_SOQL_WHERE_InIdSetClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
    XAP_DAO_SOQL_WHERE_CompareOpEnumHelper comparisonHelper;

    String fieldName;
    Set<Id> idSet;

    private XAP_DAO_SOQL_WHERE_InIdSetClause(String fieldName, Set<Id> idSet) {
        this.fieldName = fieldName;
        this.idSet = idSet;
    }

    public XAP_DAO_SOQL_WHERE_InIdSetClause(SObjectField sObjectField, Set<Id> idSet) {
        this(XAP_DAO_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField), idSet);
    }

    public XAP_DAO_SOQL_WHERE_InIdSetClause(Set<Id> idSet) {
        this('Id', idSet);
    }


    private static final String ALWAYS_FALSE = 'Id = null';

    public String toSOQL() {
        if (this.idSet == null || this.idSet.isEmpty()) {
            return ALWAYS_FALSE;
        }

        return fieldName
                + ' IN '
                + '(\''
                + String.join(new List<Id>(idSet), '\',\'')
                + '\')';
    }
}