public class XAP_UTIL_SObjectBlendResult {
	public SObject updatedSObject { get; private set; }
	public Boolean isTargetChanged;

	public XAP_UTIL_SObjectBlendResult(SObject updatedSObject) {
		this.updatedSObject = updatedSObject;
		this.isTargetChanged = false;
	}
}