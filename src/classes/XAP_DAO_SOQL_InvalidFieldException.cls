public class XAP_DAO_SOQL_InvalidFieldException extends Exception {
    private String fieldName;
    private SObjectType sObjectType;
    public XAP_DAO_SOQL_InvalidFieldException(String fieldname, SObjectType sObjectType) {
        this.sObjectType = sObjectType;
        this.fieldName = fieldName;
        this.setMessage('Invalid field \'' + fieldName + '\' for object \'' + sObjectType + '\'');
    }
}