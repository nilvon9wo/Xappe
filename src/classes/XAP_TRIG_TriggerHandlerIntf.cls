public interface XAP_TRIG_TriggerHandlerIntf {
	XAP_TRIG_TriggerEventHandlerIntf invoke();
	Type get(TriggerOperation triggerEventOperation);
}