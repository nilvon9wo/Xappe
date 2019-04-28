public virtual class XAP_REST_RequestSelector extends XAP_DAO_SOQL_SObjectSelectorAbs {
    private XAP_REST_RequestSelector() {
    }

    private static XAP_REST_RequestSelector INSTANCE;

    public static XAP_REST_RequestSelector getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new XAP_REST_RequestSelector();
        }
        return INSTANCE;
    }

    public override SObjectType getSObjectType() {
        return XAP_REST_Request__c.SObjectType;
    }

    private List<SObjectField> getSObjectFieldList() {
        return new List<SObjectField>{
                XAP_REST_Request__c.Integration_User__c,
                XAP_REST_Request__c.New_Email__c,
                XAP_REST_Request__c.Target_Email__c
        };
    }
}