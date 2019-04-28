public virtual class XAP_ASYNC_Enqueuer {
	XAP_DAO_DML_GenericDml genericDml;
	XAP_ASYNC_RequestFactory asyncRequestFactory;
	
	public XAP_ASYNC_Enqueuer(XAP_DAO_DML_GenericDml genericDml, XAP_ASYNC_RequestFactory asyncRequestFactory) {
		this.genericDml = genericDml;
		this.asyncRequestFactory = asyncRequestFactory;
	}
	 
	public XAP_ASYNC_Enqueuer() {
		this(XAP_DAO_DML_GenericDml.getInstance(), new XAP_ASYNC_RequestFactory());
	}
	
	public virtual Id enqueueJob(Queueable queueable, List<SObject> sObjectList) {
		Id asyncJobId = System.enqueueJob(queueable); 
		this.genericDml.doInsert(this.asyncRequestFactory.createFor(queueable, sObjectList, asyncJobId));
		return asyncJobId;
	}

	public virtual Id enqueueJob(Queueable queueable) {
		return this.enqueueJob(queueable, new List<SObject>());
	}
}