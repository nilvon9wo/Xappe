public class XAP_DAO_SObjectReadException extends XAP_DAO_SecurityException{
   	public XAP_DAO_SObjectReadException(Schema.SObjectType sObjectType){
   		this.sObjectType = sObjectType;

   		this.setMessage(
   			'You do not have permission to read the sObject ' + sObjectType.getDescribe().getName()
   		);
    }
}