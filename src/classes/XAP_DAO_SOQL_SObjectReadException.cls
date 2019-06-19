public class XAP_DAO_SOQL_SObjectReadException extends XAP_DAO_SOQL_SecurityException {
	public XAP_DAO_SOQL_SObjectReadException(SObjectType sObjectType) {
		this.sObjectType = sObjectType;

		this.setMessage(
				'You do not have permission to read the sObject ' + sObjectType.getDescribe().getName()
		);
	}
}