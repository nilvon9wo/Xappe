public with sharing virtual class XAP_TRIG_SObjectTypeOperationConvertor {
    public virtual List<XAP_TRIG_TriggerSObjectTypeOperation> convert(List<XAP_TRIG_TriggerWrapper> triggerWrapperList) {
    	List<XAP_TRIG_TriggerSObjectTypeOperation> operationList = new List<XAP_TRIG_TriggerSObjectTypeOperation>();
    	for (XAP_TRIG_TriggerWrapper triggerWrapper : triggerWrapperList) {
    		operationList.add(new XAP_TRIG_TriggerSObjectTypeOperation(triggerWrapper));
    	} 
    	return operationList;
    }
}