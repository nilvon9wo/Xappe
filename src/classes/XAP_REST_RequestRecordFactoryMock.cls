@IsTest
public class XAP_REST_RequestRecordFactoryMock extends XAP_REST_RequestRecordFactory {
	public XAP_REST_Request__c receivedContextRequest;
	public XAP_REST_Request__c returnRequest;
    public override XAP_REST_Request__c createAndInsertFor(XAP_REST_Request__c contextRequest) {
    	this.receivedContextRequest = contextRequest;
    	return this.returnRequest;
    }
}