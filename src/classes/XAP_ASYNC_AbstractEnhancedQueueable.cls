public abstract class XAP_ASYNC_AbstractEnhancedQueueable implements Queueable {
    XAP_ASYNC_RequestSelector asyncRequestSelector;
    XAP_ASYNC_ResultFinishFuture asyncResultFinishFuture;
    XAP_ASYNC_ResultFactory asyncResultFactory;
    XAP_DAO_TransactionHelper savePointHelper;
    XAP_DAO_DML_GenericDml genericDmlWrapper;
    XAP_UTIL_JsonHelper jsonHelper;
    XAP_UTIL_SObjectCloneFactory cloneHelper;

    public XAP_ASYNC_AbstractEnhancedQueueable(
            XAP_ASYNC_RequestSelector asyncRequestSelector,
            XAP_ASYNC_ResultFinishFuture asyncResultFinishFuture,
            XAP_ASYNC_ResultFactory asyncResultFactory,
            XAP_DAO_TransactionHelper savePointHelper,
            XAP_DAO_DML_GenericDml genericDmlWrapper,
            XAP_UTIL_JsonHelper jsonHelper,
            XAP_UTIL_SObjectCloneFactory cloneHelper
    ) {
        this.asyncRequestSelector = asyncRequestSelector;
        this.asyncResultFinishFuture = asyncResultFinishFuture;
        this.asyncResultFactory = asyncResultFactory;
        this.savePointHelper = savePointHelper;
        this.genericDmlWrapper = genericDmlWrapper;
        this.jsonHelper = jsonHelper;
        this.cloneHelper = cloneHelper;
    }

    public XAP_ASYNC_AbstractEnhancedQueueable() {
        this(
                XAP_ASYNC_RequestSelector.getInstance(),
                new XAP_ASYNC_ResultFinishFuture(),
                new XAP_ASYNC_ResultFactory(),
                new XAP_DAO_TransactionHelper(),
                XAP_DAO_DML_GenericDml.getInstance(),
                new XAP_UTIL_JsonHelper(),
                XAP_UTIL_SObjectCloneFactory.getInstance()
        );
    }

    abstract public List<XAP_ASYNC_Result__c> execute();

    protected Id asyncJobId { get; private set; }

    protected virtual List<XAP_ASYNC_Request__c> doBeforeExecute(Id asyncJobId) {
        return null;
    }

    protected virtual List<XAP_ASYNC_Result__c> doAfterExecute(List<XAP_ASYNC_Result__c> asyncResultList) {
        return asyncResultList;
    }

    protected virtual Boolean insertResultsAsynchronously() {
        return false;
    }

    @TestVisible
    protected Map<Id, XAP_ASYNC_Request__c> asyncRequestById {
        get {
            if (this.asyncRequestById == null) {
                this.asyncRequestById = new Map<Id, XAP_ASYNC_Request__c>(this.asyncRequestSelector.selectByAsyncJobId(new Set<Id>{
                        this.asyncJobId
                }));
            }
            return this.asyncRequestById;
        }
        private set;
    }

    @TestVisible
    protected Map<Id, XAP_ASYNC_Request__c> asyncRequestByRestRequestId {
        get {
            if (this.asyncRequestByRestRequestId == null) {
                List<XAP_ASYNC_Request__c> asyncRequestList = this.asyncRequestById.values();
                this.asyncRequestByRestRequestId = this.mapAsyncRequestByRestRequestId(asyncRequestList);
            }
            return this.asyncRequestByRestRequestId;
        }
        private set;
    }

    @TestVisible
    private Map<Id, XAP_ASYNC_Request__c> mapAsyncRequestByRestRequestId(List<XAP_ASYNC_Request__c> asyncRequestList) {
        Map<Id, XAP_ASYNC_Request__c> asyncRequestByRestRequestIdMap = new Map<Id, XAP_ASYNC_Request__c>();
        for (XAP_ASYNC_Request__c asyncRequest : asyncRequestList) {
            asyncRequestByRestRequestIdMap.put((Id) asyncRequest.get(XAP_ASYNC_Request__c.XAP_REST_Request__c), asyncRequest);
        }
        return asyncRequestByRestRequestIdMap;
    }

    public void execute(QueueableContext context) {
        this.asyncJobId = context.getJobId();
        this.doBeforeExecute(this.asyncJobId);
        Savepoint savePoint = this.savePointHelper.createSavePoint();

        List<XAP_ASYNC_Result__c> asyncResultList;
        try {
            asyncResultList = execute();
        }

        // Generally it is a TERRIBLE practice to catch generic exceptions,
        // but HERE, we want to capture results, no matter what.
        catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, '!!!###!!! UTIL_AbstractEnhancedQueueable Exception: ' + ex.getMessage());
            this.savePointHelper.rollback(savePoint);
            asyncResultList = this.asyncResultFactory.createResultsForUnhandledExceptions(
                    this.asyncJobId,
                    this.asyncRequestByRestRequestId,
                    ex
            );
        }

        this.asyncResultFinishFuture.asyncFinish(this.cloneHelper.perfectClone(asyncResultList));
        this.doAfterExecute(asyncResultList);
    }

    protected virtual List<XAP_ASYNC_Result__c> buildAsyncResultListFor(
            List<SObject> sObjectList,
            XAP_DAO_DML_ResultListWrapperIntf resultListWrapper
    ) {
        return this.asyncResultFactory.buildAsyncResultListFor(
                sObjectList,
                resultListWrapper,
                this.asyncJobId,
                this.asyncRequestByRestRequestId
        );
    }
}