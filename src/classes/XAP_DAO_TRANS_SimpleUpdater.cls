public class XAP_DAO_TRANS_SimpleUpdater extends XAP_DAO_TRANS_SimpleAbstractDmlable {
	public XAP_DAO_TRANS_SimpleUpdater(XAP_DAO_TRANS_SObjectListKeyEnum key, List<SObject> sObjectList) {
		super(key, sObjectList);
	}

	public XAP_DAO_TRANS_SimpleUpdater(List<SObject> sObjectList) {
		super(sObjectList);
	}

	public override XAP_DAO_DML_ResultListWrapperIntf doDml(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationModeEnum) {
		return super.genericDml.doUpdate(sObjectList, operationModeEnum);
	}
}
