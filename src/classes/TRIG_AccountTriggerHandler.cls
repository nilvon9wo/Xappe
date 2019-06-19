public class TRIG_AccountTriggerHandler extends XAP_TRIG_TriggerHandlerAbs {
	private static final Map<System.TriggerOperation, Type> EVENT_HANDLER_TYPE_BY_OPERATION_MAP
			= new Map<System.TriggerOperation, Type>{
					System.TriggerOperation.BEFORE_INSERT => CTM_AccountOwnerAssignment.class,
					System.TriggerOperation.BEFORE_UPDATE => CTM_AccountOwnerAssignment.class
			};

	public override Type get(System.TriggerOperation triggerEventOperation) {
		return EVENT_HANDLER_TYPE_BY_OPERATION_MAP.get(triggerEventOperation);
	}
}