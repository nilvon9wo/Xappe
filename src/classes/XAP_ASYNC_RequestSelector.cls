public virtual class XAP_ASYNC_RequestSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private XAP_ASYNC_RequestSelector() {
    }

    private static XAP_ASYNC_RequestSelector INSTANCE;

    public static XAP_ASYNC_RequestSelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new XAP_ASYNC_RequestSelector();
        }
        return INSTANCE;
    }

    public override SObjectType getSObjectType() {
        return XAP_ASYNC_Request__c.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                XAP_ASYNC_Request__c.Id,
                XAP_ASYNC_Request__c.Async_Job_Id__c,
                XAP_ASYNC_Request__c.Class_Name__c,
                XAP_ASYNC_Request__c.XAP_REST_Request__c,
                XAP_ASYNC_Request__c.SObject_Id__c
        };
    }

    public virtual List<XAP_ASYNC_Request__c> selectByAsyncJobId(Set<Id> asyncJobIdSet) {
        return (List<XAP_ASYNC_Request__c>) Database.query(
                this.newQueryFactory()
                        .setCondition(new XAP_DAO_SOQL_WHERE_InIdSetClause(
                                XAP_ASYNC_Request__c.Async_Job_Id__c,
                                asyncJobIdSet
                        ))
                        .toSOQL()
        );
    }
}