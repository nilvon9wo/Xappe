public class DAO_FieldLevelSecurityException extends DAO_SecurityException{
   	private Schema.SObjectField sObjectField;

   	public DAO_FieldLevelSecurityException(
   			Schema.SObjectType sObjectType, 
   			Schema.SObjectField sObjectField
   		){
   		this.sObjectType = sObjectType;
   		this.sObjectField = sObjectField; 

   		this.setMessage(
   			'You do not have permission to read the field ' + sObjectField.getDescribe().getName() 
   			+ ' on ' + sObjectType.getDescribe().getName()
   		);
    }
}