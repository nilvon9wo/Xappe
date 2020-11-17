public with sharing class XAP_TRG_TriggerSObjectTypeOperation {
	public SObjectType sObjectType { get; private set; }
	public System.TriggerOperation operation { get; private set; }

	public XAP_TRG_TriggerSObjectTypeOperation(SObjectType sObjectType, System.TriggerOperation operation) {
		this.sObjectType = sObjectType;
		this.operation = operation;
	}

	public XAP_TRG_TriggerSObjectTypeOperation(XAP_TRG_TriggerContext triggerProperties) {
		this.sObjectType = triggerProperties.sObjectType;
		this.operation = triggerProperties.operationType;
	}

	public Boolean equals(Object obj) {
		XAP_TRG_TriggerSObjectTypeOperation that = (XAP_TRG_TriggerSObjectTypeOperation) obj;
		return this.sObjectType == that.sObjectType
				&& this.operation == that.operation;
	}
}