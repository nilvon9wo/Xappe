public class XAP_DAO_InvalidFieldException extends Exception{
	private String fieldName;
	private Schema.SObjectType sObjectType;
	public XAP_DAO_InvalidFieldException(String fieldname, Schema.SObjectType sObjectType){
		this.sObjectType = sObjectType;
		this.fieldName = fieldName;
		this.setMessage( 'Invalid field \''+fieldName+'\' for object \''+sObjectType+'\'' );
	}
}