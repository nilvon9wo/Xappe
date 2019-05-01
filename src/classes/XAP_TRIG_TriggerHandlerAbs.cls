public abstract class XAP_TRIG_TriggerHandlerAbs implements XAP_TRIG_TriggerHandlerIntf {
	private XAP_TRIG_TriggerEventCoordinator triggerEventCoordinator;
	XAP_TRIG_TriggerProperties triggerProperties;
	
	public XAP_TRIG_TriggerHandlerAbs(
			XAP_TRIG_TriggerEventCoordinator triggerEventCoordinator,
			XAP_TRIG_TriggerProperties triggerProperties
	) {
		this.triggerEventCoordinator = triggerEventCoordinator;
		this.triggerProperties = triggerProperties;
	}
	
	public XAP_TRIG_TriggerHandlerAbs() {
		this(new XAP_TRIG_TriggerEventCoordinator(), new XAP_TRIG_TriggerProperties());
	}
	
    private static final Map<Type, XAP_TRIG_TriggerEventHandlerIntf> EVENT_HANDLER_INSTANCE_BY_TYPE_MAP
    	= new Map<Type, XAP_TRIG_TriggerEventHandlerIntf>{
    };
	 
    public XAP_TRIG_TriggerHandlerIntf invoke() {
    	Type triggerEventHandlerType = this.get(this.triggerProperties.operationType);
    	if (triggerEventHandlerType == null) {
    		throw new XAP_TRIG_UnassignedTriggerOpException(
    			this.triggerProperties.sObjectType + ' has no Trigger Event Handler for ' + this.triggerProperties.operationType
    		);
    	}
    	
    	if (EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.get(triggerEventHandlerType) == null) {
    		EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.put(triggerEventHandlerType, (XAP_TRIG_TriggerEventHandlerIntf) triggerEventHandlerType.newInstance());
    	}

		if (this.triggerEventCoordinator.isExecutable(this.triggerProperties)) {
			this.triggerEventCoordinator.addToInProgress(this.triggerProperties);
			EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.get(triggerEventHandlerType)
					.handle(this.triggerProperties);
			this.triggerEventCoordinator.removeFromInProgress(this.triggerProperties);
		}

		return this;
    }
    
    public abstract Type get(System.TriggerOperation triggerEventOperation);
}