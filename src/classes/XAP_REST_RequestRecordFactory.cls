public virtual class XAP_REST_RequestRecordFactory {
    XAP_DAO_DML_GenericDml genericDml;
    XAP_REST_ResponseWrapper restResponseWrapper;
    XAP_UTIL_SObjectFieldNonnullTranscriber sObjectFieldTranscriber;

    public XAP_REST_RequestRecordFactory(
            XAP_DAO_DML_GenericDml genericDml,
            XAP_REST_ResponseWrapper restResponseWrapper,
            XAP_UTIL_SObjectFieldNonnullTranscriber sObjectFieldTranscriber
    ) {
        this.genericDml = genericDml;
        this.restResponseWrapper = restResponseWrapper;
        this.sObjectFieldTranscriber = sObjectFieldTranscriber;
    }

    public XAP_REST_RequestRecordFactory() {
        this(
                XAP_DAO_DML_GenericDml.getInstance(),
                new XAP_REST_ResponseWrapper(),
                new XAP_UTIL_SObjectFieldNonnullTranscriber()
        );
    }

    private static final List<SObjectField> TRANSCRIBED_FIELD_LIST = new List<SObjectField>{
            XAP_REST_Request__c.Integration_User__c,
            XAP_REST_Request__c.Target_Email__c,
            XAP_REST_Request__c.New_Email__c,
            XAP_REST_Request__c.Params__c
    };

    public virtual XAP_REST_Request__c createAndInsertFor(XAP_REST_Request__c contextRequest) {
        XAP_REST_Request__c restRequest = this.restResponseWrapper.exportAsRecord();

        XAP_REST_Request__c finalizedRequest = (XAP_REST_Request__c) this.sObjectFieldTranscriber
                .blend(restRequest, contextRequest, TRANSCRIBED_FIELD_LIST)
                .updatedSObject;

        this.genericDml.doInsert(new List<XAP_REST_Request__c>{
                finalizedRequest
        });
        return finalizedRequest;
    }
}