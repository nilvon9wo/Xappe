@IsTest
public with sharing class XAP_DAO_ApexEmailNotificationSelMock extends XAP_DAO_ApexEmailNotificationSelector {
    public Boolean wasSelectAllCalled = false;
    public List<ApexEmailNotification> returnedApexEmailNotificationList;
    public override List<ApexEmailNotification> selectAll() {
        this.wasSelectAllCalled = true;
        return this.returnedApexEmailNotificationList;
    }
}