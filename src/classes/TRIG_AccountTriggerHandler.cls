public class TRIG_AccountTriggerHandler extends XAP_TRIG_TriggerHandlerAbs {
    private static final Map<TriggerOperation, Type> EVENT_HANDLER_TYPE_BY_OPERATION_MAP
    	= new Map<TriggerOperation, Type>{
    		TriggerOperation.BEFORE_INSERT => CTM_AccountOwnerAssignment.class,
    		TriggerOperation.BEFORE_UPDATE => CTM_AccountOwnerAssignment.class
    };

    public override Type get(TriggerOperation triggerEventOperation) {
    	return EVENT_HANDLER_TYPE_BY_OPERATION_MAP.get(triggerEventOperation);
    } 
}