@IsTest
public class XAP_TRG_SObjectTypeOperationCnvtMock extends XAP_TRG_SObjectTypeOperationConvertor {
	public List<XAP_TRG_TriggerContext> receivedTriggerPropertiesList;
	public List<XAP_TRG_TriggerSObjectTypeOperation> returnedSObjectTypeOperationList;
	public override List<XAP_TRG_TriggerSObjectTypeOperation> convert(List<XAP_TRG_TriggerContext> triggerPropertiesList) {
		this.receivedTriggerPropertiesList = triggerPropertiesList;
		return this.returnedSObjectTypeOperationList;
	}
}