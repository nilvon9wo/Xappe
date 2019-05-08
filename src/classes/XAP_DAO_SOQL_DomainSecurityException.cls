public class XAP_DAO_SOQL_DomainSecurityException extends Exception {
    public XAP_DAO_SOQL_DomainSecurityException(XAP_DAO_SOQL_SObjectReadException ex, SObjectType sObjectType) {
        this('Permission to access an ' + sObjectType.getDescribe().getName() + ' denied.', ex);
    }
}