public class TRIG_AccountTriggerHandler extends XAP_TRIG_TriggerHandlerAbs {
    private static final Map<XAP_TRIG_TriggerEventOperationEnum, Type> EVENT_HANDLER_TYPE_BY_OPERATION_MAP 
    	= new Map<XAP_TRIG_TriggerEventOperationEnum, Type>{
    		XAP_TRIG_TriggerEventOperationEnum.BEFORE_INSERT => CTM_AccountOwnerAssignment.class,
    		XAP_TRIG_TriggerEventOperationEnum.BEFORE_UPDATE => CTM_AccountOwnerAssignment.class
    };

    public override Type get(XAP_TRIG_TriggerEventOperationEnum triggerEventOperation) {
    	return EVENT_HANDLER_TYPE_BY_OPERATION_MAP.get(triggerEventOperation);
    } 
}