public interface TRIG_TriggerHandlerIntf {
	TRIG_TriggerEventHandlerIntf invoke();
	Type get(TRIG_TriggerEventOperationEnum triggerEventOperation);
}