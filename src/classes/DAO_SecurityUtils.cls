public class DAO_SecurityUtils {
	private DAO_SecurityUtils() {
	}

	private static DAO_SecurityUtils INSTANCE;
	
	public static DAO_SecurityUtils getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new DAO_SecurityUtils();
		}
		return INSTANCE; 
	}
	
	
    public static final Boolean BYPASS_INTERNAL_FLS_AND_CRUD = false;
	
    public Boolean checkFieldIsReadable(SObjectType sObjectType, String fieldName) {
    	return this.checkFieldIsReadable(sObjectType, DESC_SObjectDescribe.getDescribe(sObjectType).getField(fieldName));
    }

    public Boolean checkFieldIsReadable(SObjectType sObjectType, SObjectField fieldToken) {
    	return this.checkFieldIsReadable(sObjectType, fieldToken.getDescribe());
    } 

    public Boolean checkFieldIsReadable(SObjectType sObjectType, DescribeFieldResult fieldDescribe) {
    	if (BYPASS_INTERNAL_FLS_AND_CRUD || fieldDescribe.isAccessible()) {
    		return true; 
    	} 
            
   		throw new DAO_FieldLevelSecurityException(sObjectType, fieldDescribe.getSObjectField());
    } 
    
    public Boolean checkObjectIsReadable(SObjectType sObjectType) {
    	if (BYPASS_INTERNAL_FLS_AND_CRUD || sObjectType.getDescribe().isAccessible()) {
    		return true;
    	} 
            
       	throw new DAO_SObjectReadException(sObjectType);
    }
}