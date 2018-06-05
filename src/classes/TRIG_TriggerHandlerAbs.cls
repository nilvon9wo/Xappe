public abstract class TRIG_TriggerHandlerAbs implements TRIG_TriggerHandlerIntf {
	TRIG_TriggerWrapper triggerWrapper;
	
	public TRIG_TriggerHandlerAbs(TRIG_TriggerWrapper triggerWrapper) {
		this.triggerWrapper = triggerWrapper;
	}
	
	public TRIG_TriggerHandlerAbs() {
		this(new TRIG_TriggerWrapper());
	}
	
    private static final Map<Type, TRIG_TriggerEventHandlerIntf> EVENT_HANDLER_INSTANCE_BY_TYPE_MAP 
    	= new Map<Type, TRIG_TriggerEventHandlerIntf>{
    };
	 
    public TRIG_TriggerEventHandlerIntf invoke() {
    	Type triggerEventHandlerType = this.get(this.triggerWrapper.operation);
    	if (triggerEventHandlerType == null) {
    		throw new TRIG_UnassignedTriggerOperationException(
    			this.triggerWrapper.sObjectType + ' has no Trigger Event Handler for ' + this.triggerWrapper.operation
    		);
    	}
    	
    	if (EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.get(triggerEventHandlerType) == null) {
    		EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.put(triggerEventHandlerType, (TRIG_TriggerEventHandlerIntf) triggerEventHandlerType.newInstance());
    	}
    	
    	return EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.get(triggerEventHandlerType)
    		.handle(this.triggerWrapper);
    }
    
    public abstract Type get(TRIG_TriggerEventOperationEnum triggerEventOperation); 
}