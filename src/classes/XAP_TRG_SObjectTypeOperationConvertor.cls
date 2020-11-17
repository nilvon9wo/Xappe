public with sharing virtual class XAP_TRG_SObjectTypeOperationConvertor {
	public virtual List<XAP_TRG_TriggerSObjectTypeOperation> convert(List<XAP_TRG_TriggerContext> triggerPropertiesList) {
		List<XAP_TRG_TriggerSObjectTypeOperation> operationList = new List<XAP_TRG_TriggerSObjectTypeOperation>();
		for (XAP_TRG_TriggerContext triggerProperties : triggerPropertiesList) {
			operationList.add(new XAP_TRG_TriggerSObjectTypeOperation(triggerProperties));
		}
		return operationList;
	}
}