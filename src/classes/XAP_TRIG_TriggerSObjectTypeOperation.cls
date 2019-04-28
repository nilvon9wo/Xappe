public with sharing class XAP_TRIG_TriggerSObjectTypeOperation {
	public SObjectType sObjectType {get; private set;}
	public System.TriggerOperation operation {get; private set;}
	
	public XAP_TRIG_TriggerSObjectTypeOperation(SObjectType sObjectType, System.TriggerOperation operation) {
		this.sObjectType = sObjectType;
		this.operation = operation; 
	}
	
	public XAP_TRIG_TriggerSObjectTypeOperation(XAP_TRIG_TriggerWrapper triggerWrapper) {
		this.sObjectType = triggerWrapper.sObjectType;
		this.operation = triggerWrapper.operationType;
	}
 
	public Boolean equals(Object obj) {
		XAP_TRIG_TriggerSObjectTypeOperation that = (XAP_TRIG_TriggerSObjectTypeOperation) obj;
		return this.sObjectType == that.sObjectType
			&& this.operation == that.operation;
	}
}