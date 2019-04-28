public abstract class XAP_TRIG_TriggerHandlerAbs implements XAP_TRIG_TriggerHandlerIntf {
	XAP_TRIG_TriggerWrapper triggerWrapper;
	
	public XAP_TRIG_TriggerHandlerAbs(XAP_TRIG_TriggerWrapper triggerWrapper) {
		this.triggerWrapper = triggerWrapper;
	}
	
	public XAP_TRIG_TriggerHandlerAbs() {
		this(new XAP_TRIG_TriggerWrapper());
	}
	
    private static final Map<Type, XAP_TRIG_TriggerEventHandlerIntf> EVENT_HANDLER_INSTANCE_BY_TYPE_MAP 
    	= new Map<Type, XAP_TRIG_TriggerEventHandlerIntf>{
    };
	 
    public XAP_TRIG_TriggerEventHandlerIntf invoke() {
    	Type triggerEventHandlerType = this.get(this.triggerWrapper.operation);
    	if (triggerEventHandlerType == null) {
    		throw new XAP_TRIG_UnassignedTriggerOpException(
    			this.triggerWrapper.sObjectType + ' has no Trigger Event Handler for ' + this.triggerWrapper.operation
    		);
    	}
    	
    	if (EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.get(triggerEventHandlerType) == null) {
    		EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.put(triggerEventHandlerType, (XAP_TRIG_TriggerEventHandlerIntf) triggerEventHandlerType.newInstance());
    	}
    	
    	return EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.get(triggerEventHandlerType)
    		.handle(this.triggerWrapper);
    }
    
    public abstract Type get(TriggerOperation triggerEventOperation);
}