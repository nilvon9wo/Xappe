public abstract class XAP_TRIG_TriggerHandlerAbs implements XAP_TRIG_TriggerHandlerIntf {
	private XAP_TRIG_TriggerEventCoordinator triggerEventCoordinator;
	XAP_TRIG_TriggerWrapper triggerWrapper;
	
	public XAP_TRIG_TriggerHandlerAbs(
			XAP_TRIG_TriggerEventCoordinator triggerEventCoordinator,
			XAP_TRIG_TriggerWrapper triggerWrapper
	) {
		this.triggerEventCoordinator = triggerEventCoordinator;
		this.triggerWrapper = triggerWrapper;
	}
	
	public XAP_TRIG_TriggerHandlerAbs() {
		this(new XAP_TRIG_TriggerEventCoordinator(), new XAP_TRIG_TriggerWrapper());
	}
	
    private static final Map<Type, XAP_TRIG_TriggerEventHandlerIntf> EVENT_HANDLER_INSTANCE_BY_TYPE_MAP
    	= new Map<Type, XAP_TRIG_TriggerEventHandlerIntf>{
    };
	 
    public XAP_TRIG_TriggerHandlerIntf invoke() {
    	Type triggerEventHandlerType = this.get(this.triggerWrapper.operationType);
    	if (triggerEventHandlerType == null) {
    		throw new XAP_TRIG_UnassignedTriggerOpException(
    			this.triggerWrapper.sObjectType + ' has no Trigger Event Handler for ' + this.triggerWrapper.operationType
    		);
    	}
    	
    	if (EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.get(triggerEventHandlerType) == null) {
    		EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.put(triggerEventHandlerType, (XAP_TRIG_TriggerEventHandlerIntf) triggerEventHandlerType.newInstance());
    	}

		if (this.triggerEventCoordinator.isExecutable(this.triggerWrapper)) {
			this.triggerEventCoordinator.addToInProgress(this.triggerWrapper);
			EVENT_HANDLER_INSTANCE_BY_TYPE_MAP.get(triggerEventHandlerType)
					.handle(this.triggerWrapper);
			this.triggerEventCoordinator.removeFromInProgress(this.triggerWrapper);
		}

		return this;
    }
    
    public abstract Type get(System.TriggerOperation triggerEventOperation);
}