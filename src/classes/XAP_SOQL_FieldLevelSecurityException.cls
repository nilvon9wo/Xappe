public class XAP_SOQL_FieldLevelSecurityException extends XAP_SOQL_SecurityException{
   	private Schema.SObjectField sObjectField;

   	public XAP_SOQL_FieldLevelSecurityException(
   			Schema.SObjectType sObjectType,
   			Schema.SObjectField sObjectField
   		){
   		this.SObjectType = sObjectType;
   		this.sObjectField = sObjectField; 

   		this.setMessage(
   			'You do not have permission to read the field ' + sObjectField.getDescribe().getName() 
   			+ ' on ' + sObjectType.getDescribe().getName()
   		);
    }
}