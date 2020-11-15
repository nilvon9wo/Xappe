public with sharing virtual class XAP_EML_EmailMailer {
    private XAP_DAO_ApexEmailNotificationSelector apexEmailNotificationSelector;

    @TestVisible
    private XAP_EML_EmailMailer(XAP_DAO_ApexEmailNotificationSelector apexEmailNotificationSelector) {
        this.apexEmailNotificationSelector = apexEmailNotificationSelector;
    }

    protected XAP_EML_EmailMailer() {
        this(XAP_DAO_ApexEmailNotificationSelector.getInstance());
    }

    private static XAP_EML_EmailMailer instance;
    public static XAP_EML_EmailMailer getInstance() {
        if (instance == null) {
            instance = new XAP_EML_EmailMailer();
        }
        return instance;
    }

    // This enables workaround to prove emails would be sent even in orgs where email is disabled.
    @TestVisible
    private static Integer MESSAGES_SENT_COUNT = 0;

    public virtual XAP_EML_SendEmailResultListWrapper sendExceptionAlerts(XAP_EML_EmailAlertable alertable) {
        Map<Type, List<Object>> recipientsByTypeMap = buildRecipientsByTypeMap();
        List<User> userList = (List<User>) recipientsByTypeMap.get(User.class);
        List<String> emailAddressList = (List<String>) recipientsByTypeMap.get(String.class);
        List<Messaging.SingleEmailMessage> emailMessageList
                = this.buildEmailMessageList(userList, emailAddressList, alertable);
        return this.send(emailMessageList);
    }

    @TestVisible
    private Map<Type, List<Object>> buildRecipientsByTypeMap() {
        List<User> userList = new List<User>();
        List<String> emailAddressList = new List<String>();
        for (ApexEmailNotification apexEmailNotification : this.apexEmailNotificationSelector.selectAll()) {
            if (apexEmailNotification.User != null) {
                userList.add(apexEmailNotification.User);
            }
            else {
                emailAddressList.add(apexEmailNotification.Email);
            }
        }
        return new Map<Type, List<Object>>{
                User.class => userList,
                String.class => emailAddressList
        };
    }

    @TestVisible
    private List<Messaging.SingleEmailMessage> buildEmailMessageList(
            List<User> userList,
            List<String> emailAddressList,
            XAP_EML_EmailAlertable alertable
    ) {
        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        emailMessageList.addAll(this.buildEmailMessageList(userList, alertable));
        emailMessageList.addAll(this.buildEmailMessageList(emailAddressList, alertable));
        return emailMessageList;
    }

    @TestVisible
    private List<Messaging.SingleEmailMessage> buildEmailMessageList(
            List<User> userList,
            XAP_EML_EmailAlertable alertable
    ) {
        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        for (User user : userList) {
            Messaging.SingleEmailMessage email = this.createEmail(alertable);
            email.setTargetObjectId(user.Id);
            emailMessageList.add(email);
        }
        return emailMessageList;
    }

    @TestVisible
    private List<Messaging.SingleEmailMessage> buildEmailMessageList(
            List<String> emailAddressList,
            XAP_EML_EmailAlertable alertable
    ) {
        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        if (!emailAddressList.isEmpty()) {
            Messaging.SingleEmailMessage email = this.createEmail(alertable);
            email.setToAddresses(emailAddressList);
            emailMessageList.add(email);
        }
        return emailMessageList;
    }

    @TestVisible
    private Messaging.SingleEmailMessage createEmail(XAP_EML_EmailAlertable alertable) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSaveAsActivity(false);
        email.setSubject(alertable.getEmailSubject());
        email.setPlainTextBody(alertable.getEmailBody());
        return email;
    }

    @TestVisible
    private static XAP_EML_SendEmailResultListWrapper TEST_EMAIL_RESULT_WRAPPER;
    public virtual XAP_EML_SendEmailResultListWrapper send(List<Messaging.SingleEmailMessage> emailMessageList) {
        MESSAGES_SENT_COUNT++;
        return (Test.isRunningTest() && TEST_EMAIL_RESULT_WRAPPER != null)
                ? TEST_EMAIL_RESULT_WRAPPER
                : new XAP_EML_SendEmailResultListWrapper(
                        Messaging.sendEmail(emailMessageList)
                );
    }

    public virtual XAP_EML_EmailMailer reserveSingleEmailCapacity(Integer emailCount) {
        Messaging.reserveSingleEmailCapacity(emailCount);
        return this;
    }
}