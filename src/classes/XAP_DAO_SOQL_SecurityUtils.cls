public class XAP_DAO_SOQL_SecurityUtils {
	private XAP_DAO_SOQL_SecurityUtils() {
	}

	private static XAP_DAO_SOQL_SecurityUtils instance;
	
	public static XAP_DAO_SOQL_SecurityUtils getInstance() {
		if (instance == null) {
			instance = new XAP_DAO_SOQL_SecurityUtils();
		}
		return instance;
	}
	
	
    public static final Boolean BYPASS_INTERNAL_FLS_AND_CRUD = false;
	
    public Boolean checkFieldIsReadable(SObjectType sObjectType, String fieldName) {
    	return this.checkFieldIsReadable(sObjectType, XAP_DESC_SObjectDescribe.getDescribe(sObjectType).getField(fieldName));
    }

    public Boolean checkFieldIsReadable(SObjectType sObjectType, SObjectField fieldToken) {
    	return this.checkFieldIsReadable(sObjectType, fieldToken.getDescribe());
    } 

    public Boolean checkFieldIsReadable(SObjectType sObjectType, DescribeFieldResult fieldDescribe) {
    	if (BYPASS_INTERNAL_FLS_AND_CRUD || fieldDescribe.isAccessible()) {
    		return true; 
    	} 
            
   		throw new XAP_DAO_SOQL_FieldLevelSecurityException(sObjectType, fieldDescribe.getSObjectField());
    } 
    
    public Boolean checkObjectIsReadable(SObjectType sObjectType) {
    	if (BYPASS_INTERNAL_FLS_AND_CRUD || sObjectType.getDescribe().isAccessible()) {
    		return true;
    	} 
            
       	throw new XAP_DAO_SOQL_SObjectReadException(sObjectType);
    }
}
