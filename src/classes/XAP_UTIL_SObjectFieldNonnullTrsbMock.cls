@IsTest
public class XAP_UTIL_SObjectFieldNonnullTrsbMock extends XAP_UTIL_SObjectFieldNonnullTranscriber {
	public SObject receivedTargetSObject;
	public SObject receivedProviderSObject;
	public List<SObjectField> receivedFieldList;
	public XAP_UTIL_SObjectBlendResult returnResult;
	public override XAP_UTIL_SObjectBlendResult blend(
			SObject targetSObject,
			SObject providerSObject,
			List<SObjectField> fieldList
	) {
		this.receivedTargetSObject = targetSObject;
		this.receivedProviderSObject = providerSObject;
		this.receivedFieldList = fieldList;
		return this.returnResult;
	}
}