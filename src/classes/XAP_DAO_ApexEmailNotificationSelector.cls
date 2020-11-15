public with sharing virtual class XAP_DAO_ApexEmailNotificationSelector {
    protected XAP_DAO_ApexEmailNotificationSelector() {
    }

    private static XAP_DAO_ApexEmailNotificationSelector instance;
    public static XAP_DAO_ApexEmailNotificationSelector getInstance() {
        if (instance == null) {
            instance = new XAP_DAO_ApexEmailNotificationSelector();
        }
        return instance;
    }

    public virtual List<ApexEmailNotification> selectAll() {
        return [
                SELECT User.Id, Email
                FROM ApexEmailNotification
        ];
    }
}