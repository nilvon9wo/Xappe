public class XAP_SOQL_InvalidFieldException extends Exception{
	private String fieldName;
	private Schema.SObjectType sObjectType;
	public XAP_SOQL_InvalidFieldException(String fieldname, Schema.SObjectType sObjectType){
		this.SObjectType = sObjectType;
		this.fieldName = fieldName;
		this.setMessage( 'Invalid field \''+fieldName+'\' for object \''+sObjectType+'\'' );
	}
}