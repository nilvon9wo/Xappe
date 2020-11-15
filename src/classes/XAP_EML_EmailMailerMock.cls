@IsTest
public with sharing class XAP_EML_EmailMailerMock extends XAP_EML_EmailMailer {
	public XAP_EML_SendEmailResultListWrapper returnedSendEmailResultListWrapper;

	public XAP_EML_EmailAlertable receivedAlertable;
	public override XAP_EML_SendEmailResultListWrapper sendExceptionAlerts(XAP_EML_EmailAlertable alertable) {
		this.receivedAlertable = alertable;
		return this.returnedSendEmailResultListWrapper;
	}

	public List<Messaging.SingleEmailMessage> receivedSingleEmailMessageList;
	public override XAP_EML_SendEmailResultListWrapper send(List<Messaging.SingleEmailMessage> singleEmailMessageList) {
		this.receivedSingleEmailMessageList = singleEmailMessageList;
		return this.returnedSendEmailResultListWrapper;
	}

	public Integer receivedEmailCount;
	public Exception thrownReserveException;
	public override XAP_EML_EmailMailer reserveSingleEmailCapacity(Integer emailCount) {
		this.receivedEmailCount = emailCount;
		if (thrownReserveException != null) {
			throw thrownReserveException;
		}
		return this;
	}
}