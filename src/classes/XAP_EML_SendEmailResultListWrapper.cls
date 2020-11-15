global with sharing class XAP_EML_SendEmailResultListWrapper extends XAP_EML_SendEmailResultListWrapperAbs {
	@TestVisible private transient List<Messaging.SendEmailResult> sendEmailResults;
	@TestVisible private List<XAP_EML_SendEmailResultWrapper> resultWrapperList;

	public XAP_EML_SendEmailResultListWrapper(List<Messaging.SendEmailResult> sendEmailResults) {
		this.sendEmailResults = sendEmailResults;
	}

	@TestVisible
	private XAP_EML_SendEmailResultListWrapper() {
	}

	public override List<XAP_EML_SendEmailResultWrapperIntf> getResultWrapperList() {
		if (this.resultWrapperList == null) {
			this.resultWrapperList = new List<XAP_EML_SendEmailResultWrapper>();
			for (Messaging.SendEmailResult sendEmailResult : sendEmailResults) {
				resultWrapperList.add(new XAP_EML_SendEmailResultWrapper(sendEmailResult));
			}
		}
		return this.resultWrapperList;
	}
}