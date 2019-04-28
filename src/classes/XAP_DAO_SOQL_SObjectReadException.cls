public class XAP_DAO_SOQL_SObjectReadException extends XAP_DAO_SOQL_SecurityException{
   	public XAP_DAO_SOQL_SObjectReadException(Schema.SObjectType sObjectType){
   		this.SObjectType = sObjectType;

   		this.setMessage(
   			'You do not have permission to read the sObject ' + sObjectType.getDescribe().getName()
   		);
    }
}