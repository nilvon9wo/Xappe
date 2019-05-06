@IsTest
public class XAP_TRIG_SObjectTypeOperationCnvtMock extends XAP_TRIG_SObjectTypeOperationConvertor {
	public List<XAP_TRIG_TriggerProperties> receivedTriggerPropertiesList;
	public List<XAP_TRIG_TriggerSObjectTypeOperation> returnedSObjectTypeOperationList;
    public override List<XAP_TRIG_TriggerSObjectTypeOperation> convert(List<XAP_TRIG_TriggerProperties> triggerPropertiesList) {
    	this.receivedTriggerPropertiesList = triggerPropertiesList;
    	return this.returnedSObjectTypeOperationList; 
    }
}