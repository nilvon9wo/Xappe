public class DAO_SObjectReadException extends DAO_SecurityException{
   	public DAO_SObjectReadException(Schema.SObjectType sObjectType){
   		this.sObjectType = sObjectType;

   		this.setMessage(
   			'You do not have permission to read the sObject ' + sObjectType.getDescribe().getName()
   		);
    }
}