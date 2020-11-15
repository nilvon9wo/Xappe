public with sharing class XAP_EML_SendEmailErrorRewrapper {
	public List<XAP_EML_SendEmailErrorWrapper> convert(List<Messaging.SendEmailError> SendEmailErrorList) {
		List<XAP_EML_SendEmailErrorWrapper> wrapperList = new List<XAP_EML_SendEmailErrorWrapper>();
		if (SendEmailErrorList != null) {
			for (Messaging.SendEmailError sendEmailError : SendEmailErrorList) {
				wrapperList.add(new XAP_EML_SendEmailErrorWrapper(sendEmailError));
			}
		}
		return wrapperList;
	}
}