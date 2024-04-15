public with sharing class XAP_EML_EmailAlertableMock implements XAP_EML_EmailAlertable {
    public String returnedEmailSubject;
    public String getEmailSubject() {
        return returnedEmailSubject;
    }

    public String returnedEmailBody;
    public String getEmailBody() {
        return returnedEmailBody;
    }

}