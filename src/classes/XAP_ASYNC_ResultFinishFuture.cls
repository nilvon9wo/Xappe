public class XAP_ASYNC_ResultFinishFuture {
    DAO_UserSelector userSelector;
    XAP_ASYNC_RequestSelector asyncRequestSelector;
    XAP_DAO_DML_GenericDml genericDml;
    XAP_TRIG_TriggerEventCoordinator triggerEventCoordinator;
    XAP_UTIL_SObjectListExtractor listExtractor;
    XAP_UTIL_SObjectListSetter listSetter;
    XAP_UTIL_SObjectSetExtractor setHelper;
    XAP_UTIL_JsonHelper jsonHelper;

    public XAP_ASYNC_ResultFinishFuture(
            DAO_UserSelector userSelector,
            XAP_ASYNC_RequestSelector asyncRequestSelector,
            XAP_DAO_DML_GenericDml genericDml,
            XAP_TRIG_TriggerEventCoordinator triggerEventCoordinator,
            XAP_UTIL_SObjectListExtractor listExtractor,
            XAP_UTIL_SObjectListSetter listSetter,
            XAP_UTIL_SObjectSetExtractor setHelper,
            XAP_UTIL_JsonHelper jsonHelper
    ) {
        this.userSelector = userSelector;
        this.asyncRequestSelector = asyncRequestSelector;
        this.genericDml = genericDml;
        this.triggerEventCoordinator = triggerEventCoordinator;
        this.listExtractor = listExtractor;
        this.listSetter = listSetter;
        this.setHelper = setHelper;
        this.jsonHelper = jsonHelper;
    }

    public XAP_ASYNC_ResultFinishFuture() {
        this(
                DAO_UserSelector.getInstance(),
                XAP_ASYNC_RequestSelector.getInstance(),
                XAP_DAO_DML_GenericDml.getInstance(),
                new XAP_TRIG_TriggerEventCoordinator(),
                XAP_UTIL_SObjectListExtractor.getInstance(),
                XAP_UTIL_SObjectListSetter.getInstance(),
                XAP_UTIL_SObjectSetExtractor.getInstance(),
                new XAP_UTIL_JsonHelper()
        );
    }

    private static final Set<SObjectType> TRIGGERS_TO_TOGGLE_SET = new Set<SObjectType>{
            Contact.SObjectType,
            User.SObjectType
    };

    public List<XAP_ASYNC_Result__c> asyncFinish(List<XAP_ASYNC_Result__c> asyncResultList) {
        XAP_ASYNC_ResultFinishFuture.futureFinish(this.jsonHelper.serialize(asyncResultList));
        return asyncResultList;
    }

    @Future
    public static void futureFinish(String asyncResultListAsJsonList) {
        (new XAP_ASYNC_ResultFinishFuture()).doFinish(asyncResultListAsJsonList);
    }

    @TestVisible
    private List<XAP_ASYNC_Request__c> doFinish(String asyncResultListAsJsonList) {
        return this.doFinish((List<XAP_ASYNC_Result__c>) this.jsonHelper.deserialize(asyncResultListAsJsonList, List<XAP_ASYNC_Result__c>.class));
    }

    @TestVisible
    private List<XAP_ASYNC_Request__c> doFinish(List<XAP_ASYNC_Result__c> asyncResultList) {
        this.genericDml.doInsert(asyncResultList, XAP_DAO_DML_GenericDml.NOT_ALL_OR_NONE);
        return this.resetOfCurrentRestRequests(this.setHelper.extractNonNullIdsFrom(asyncResultList, XAP_ASYNC_Result__c.Async_Request__c));
    }

    @TestVisible
    private List<XAP_ASYNC_Request__c> resetOfCurrentRestRequests(Set<Id> asyncRequestIdSet) {
        List<XAP_ASYNC_Request__c> asyncRequestList = this.asyncRequestSelector.selectById(asyncRequestIdSet);

        Collections collections = new Collections(
                this.listExtractor.extractWhereNotNullFrom(asyncRequestList, XAP_ASYNC_Request__c.XAP_REST_Request__c)
        );
        List<SObject> sObjectList = collections.sObjectList;
        sObjectList.addAll((List<SObject>) this.prepareContacts(collections.userIdSet));
        this.listSetter.setAllNull(sObjectList, 'Current_XAP_REST_Request__c');

        this.triggerEventCoordinator.dynamicDisable(TRIGGERS_TO_TOGGLE_SET);
        this.genericDml.doUpdate(sObjectList);
        this.triggerEventCoordinator.dynamicEnable(TRIGGERS_TO_TOGGLE_SET);

        return asyncRequestList;
    }

    @TestVisible
    private List<Contact> prepareContacts(Set<Id> userIdSet) {
        List<User> userList = this.userSelector.selectById(userIdSet);
        Set<Id> contactIdSet = this.setHelper.extractNonNullIdsFrom(userList, User.ContactId);

        List<Contact> contactList = new List<Contact>();
        for (Id contactId : contactIdSet) {
            contactList.add(new Contact(Id = contactId));
        }
        return contactList;
    }

    @TestVisible
    private class Collections {
        Set<Id> userIdSet = new Set<Id>();
        List<SObject> sObjectList = new List<SObject>();

        public Collections(List<XAP_ASYNC_Request__c> asyncRequestList) {
            for (XAP_ASYNC_Request__c asyncRequest : asyncRequestList) {
                this.collectFor(asyncRequest);
            }
        }

        @TestVisible
        private void collectFor(XAP_ASYNC_Request__c asyncRequest) {
            Id sObjectId = (Id) asyncRequest.SObject_Id__c;
            SObjectType sObjectType = sObjectId.getSobjectType();

            if (sObjectType == User.SObjectType) {
                this.userIdSet.add(sObjectId);
            }

            this.sObjectList.add(sObjectType.newSObject(sObjectId));
        }
    }

}