public with sharing class XAP_TRIG_TriggerSObjectTypeOperation {
	public SObjectType sObjectType { get; private set; }
	public System.TriggerOperation operation { get; private set; }

	public XAP_TRIG_TriggerSObjectTypeOperation(SObjectType sObjectType, System.TriggerOperation operation) {
		this.sObjectType = sObjectType;
		this.operation = operation;
	}

	public XAP_TRIG_TriggerSObjectTypeOperation(XAP_TRIG_TriggerProperties triggerProperties) {
		this.sObjectType = triggerProperties.sObjectType;
		this.operation = triggerProperties.operationType;
	}

	public Boolean equals(Object obj) {
		XAP_TRIG_TriggerSObjectTypeOperation that = (XAP_TRIG_TriggerSObjectTypeOperation) obj;
		return this.sObjectType == that.sObjectType
				&& this.operation == that.operation;
	}
}