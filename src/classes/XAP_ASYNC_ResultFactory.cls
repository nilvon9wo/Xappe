public virtual class XAP_ASYNC_ResultFactory {
    XAP_UTIL_JsonHelper jsonHelper;

    public XAP_ASYNC_ResultFactory(XAP_UTIL_JsonHelper jsonHelper) {
        this.jsonHelper = jsonHelper;
    }

    public XAP_ASYNC_ResultFactory() {
        this(new XAP_UTIL_JsonHelper());
    }

    private static final String FAILURE_RECORD_TYPE_NAME = 'Failure';
    private static final String SUCCESS_RECORD_TYPE_NAME = 'Success';

    private static final Map<String, Schema.RecordTypeInfo> ASYNC_RESULT_RECORD_TYPE_INFO_BY_DEVELOPER_NAME_MAP
            = XAP_ASYNC_Result__c.SObjectType.getDescribe()
                    .getRecordTypeInfosByDeveloperName();
    private static final Id FAILURE_RECORD_TYPE_ID = ASYNC_RESULT_RECORD_TYPE_INFO_BY_DEVELOPER_NAME_MAP
            .get(FAILURE_RECORD_TYPE_NAME)
            .getRecordTypeId();
    private static final Id SUCCESS_RECORD_TYPE_ID = ASYNC_RESULT_RECORD_TYPE_INFO_BY_DEVELOPER_NAME_MAP
            .get(SUCCESS_RECORD_TYPE_NAME)
            .getRecordTypeId();

    public virtual List<XAP_ASYNC_Result__c> buildAsyncResultListFor(
            List<SObject> sObjectList,
            XAP_DAO_DML_ResultListWrapperIntf resultListWrapper,
            Id asyncJobId,
            Map<Id, XAP_ASYNC_Request__c> asyncRequestByRestRequestIdMap
    ) {
        List<XAP_ASYNC_Result__c> asyncResultList = new List<XAP_ASYNC_Result__c>();

        List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList = resultListWrapper.getResultWrapperList();
        for (Integer i = 0; i < sObjectList.size(); i++) {
            asyncResultList.add(
                    this.buildAsyncResultFor(
                            sObjectList[i],
                            resultWrapperList[i],
                            asyncJobId,
                            asyncRequestByRestRequestIdMap
                    )
            );
        }
        return asyncResultList;
    }

    @TestVisible
    private XAP_ASYNC_Result__c buildAsyncResultFor(
            SObject sObj,
            XAP_DAO_DML_ResultWrapperIntf resultWrapper,
            Id asyncJobId,
            Map<Id, XAP_ASYNC_Request__c> asyncRequestByRestRequestIdMap
    ) {
        Id restRequestId = this.getCurrentRequestId(sObj);
        Id asyncRequestId = (asyncRequestByRestRequestIdMap != null)
                ? asyncRequestByRestRequestIdMap.get(restRequestId).Id
                : null;

        return resultWrapper.isSuccess()
                ? createForSuccess(asyncJobId, asyncRequestId, restRequestId)
                : createForDmlFailure(asyncJobId, asyncRequestId, restRequestId, sObj, resultWrapper);
    }

    @TestVisible
    private Id getCurrentRequestId(SObject sObj) {
        Id requestId;
        try {
            requestId = (Id) sObj.get('Current_XAP_REST_Request__c');
        } catch (System.SObjectException ex) {
        }
        return requestId;
    }

    // Concrete XAP_ASYNC_Result__c records -------------------------------------------------

    public XAP_ASYNC_Result__c createForSuccess(Id asyncJobId, Id asyncRequestId, Id restRequestId) {
        return new XAP_ASYNC_Result__c(
                RecordTypeId = SUCCESS_RECORD_TYPE_ID,
                Async_Job_Id__c = asyncJobId,
                Async_Request__c = asyncRequestId,
                REST_Request__c = restRequestId
        );
    }

    public XAP_ASYNC_Result__c createForDmlFailure(
            Id asyncJobId,
            Id asyncRequestId,
            Id restRequestId,
            SObject unsavedSObject,
            XAP_DAO_DML_ResultWrapperIntf resultWrapper
    ) {
        return new XAP_ASYNC_Result__c(
                RecordTypeId = FAILURE_RECORD_TYPE_ID,
                Async_Job_Id__c = asyncJobId,
                Async_Request__c = asyncRequestId,
                REST_Request__c = restRequestId,

                Message__c = String.join(resultWrapper.getErrorList(), ';'),
                DML_Errors__c = this.jsonHelper.serialize(resultWrapper.getErrorList()),
                Unsaved_Record__c = this.jsonHelper.serialize(unsavedSObject),

                Unexpected_Exception__c = false,
                Unhandled_Exception__c = true
        );
    }

    public List<XAP_ASYNC_Result__c> createResultsForUnhandledExceptions(
            Id asyncJobId,
            Map<Id, XAP_ASYNC_Request__c> asyncRequestByRestRequestIdMap,
            Exception ex
    ) {
        List<XAP_ASYNC_Result__c> asyncResultList = new List<XAP_ASYNC_Result__c>();
        for (Id restRequestId : asyncRequestByRestRequestIdMap.keySet()) {

            Id asyncRequestId = (asyncRequestByRestRequestIdMap != null)
                    ? asyncRequestByRestRequestIdMap.get(restRequestId).Id
                    : null;

            asyncResultList.add(new XAP_ASYNC_Result__c(
                    RecordTypeId = FAILURE_RECORD_TYPE_ID,
                    Async_Job_Id__c = asyncJobId,
                    Async_Request__c = asyncRequestId,
                    REST_Request__c = restRequestId,

                    Exception_Type_Name__c = ex.getTypeName(),
                    Message__c = ex.getMessage(),
                    Cause__c = this.jsonHelper.serialize(ex.getCause()),
                    Line_Number__c = ex.getLineNumber(),
                    Stack_Trace__c = ex.getStackTraceString(),

                    Unexpected_Exception__c = true,
                    Unhandled_Exception__c = true
            ));
        }
        return asyncResultList;
    }
}