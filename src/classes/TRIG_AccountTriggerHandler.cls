public class TRIG_AccountTriggerHandler extends TRIG_TriggerHandlerAbs {
    private static final Map<TRIG_TriggerEventOperationEnum, Type> EVENT_HANDLER_TYPE_BY_OPERATION_MAP 
    	= new Map<TRIG_TriggerEventOperationEnum, Type>{
    		TRIG_TriggerEventOperationEnum.BEFORE_INSERT => CTM_AccountOwnerAssignment.class,
    		TRIG_TriggerEventOperationEnum.BEFORE_UPDATE => CTM_AccountOwnerAssignment.class
    };

    public override Type get(TRIG_TriggerEventOperationEnum triggerEventOperation) {
    	return EVENT_HANDLER_TYPE_BY_OPERATION_MAP.get(triggerEventOperation);
    }
}