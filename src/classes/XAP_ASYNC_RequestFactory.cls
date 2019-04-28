public virtual class XAP_ASYNC_RequestFactory {
	XAP_UTIL_ClassHelper classHelper;
	
	public XAP_ASYNC_RequestFactory(XAP_UTIL_ClassHelper classHelper) {
		this.classHelper = classHelper;
	}
	
	public XAP_ASYNC_RequestFactory() {
		this(new XAP_UTIL_ClassHelper());
	} 
	
    public List<XAP_ASYNC_Request__c> createFor(Queueable queueable, List<SObject> sObjectList, Id asyncJobId) {
		List<XAP_ASYNC_Request__c> requestJobList = new List<XAP_ASYNC_Request__c>();
    	
    	if (String.isBlank(asyncJobId)) {
    		System.debug(LoggingLevel.WARN, 'asyncJobId is missing.');
    	
    		// SFDC may not provide this value for tests, causing integration tests to fail.  :-(	
    		if (Test.isRunningTest()) {
    			return requestJobList;	
    		}
    		// We want errors outside of testing conditions!
    	}

		for (SObject sObj : sObjectList) {
			requestJobList.add(new XAP_ASYNC_Request__c(
					Class_Name__c = this.classHelper.getClassName(queueable),
					SObject_Id__c = sObj.Id,
					XAP_REST_Request__c	= this.getCurrentRequestId(sObj),
					Async_Job_Id__c = asyncJobId
			));
		}
    	return requestJobList;
    }
    
    @TestVisible
    private Id getCurrentRequestId(SObject sObj) {
    	Id requestId;
		try  {
			requestId = (Id) sObj.get('Current_XAP_REST_Request__c');
		}
		catch (System.SObjectException ex) {
		}    	
		return requestId;
    }
    
    
}