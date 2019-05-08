public class XAP_DAO_SOQL_SObjectFieldHelper {
    XAP_DAO_SOQL_SecurityUtils securityUtils;

    private XAP_DAO_SOQL_SObjectFieldHelper(XAP_DAO_SOQL_SecurityUtils securityUtils) {
        this.securityUtils = securityUtils;
    }

    private XAP_DAO_SOQL_SObjectFieldHelper() {
        this(XAP_DAO_SOQL_SecurityUtils.getInstance());
    }

    private static XAP_DAO_SOQL_SObjectFieldHelper instance;

    public static XAP_DAO_SOQL_SObjectFieldHelper getInstance() {
        instance = new XAP_DAO_SOQL_SObjectFieldHelper();
        return instance;
    }

    public String getFieldTokenPath(Schema.SObjectField field) {
        if (field == null) {
            throw new XAP_DAO_SOQL_InvalidFieldException('Invalid field: null');
        }
        return field.getDescribe().getName();
    }
}