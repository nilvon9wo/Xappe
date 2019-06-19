public class XAP_DAO_TRANS_SimpleUpserter implements XAP_DAO_TRANS_DmlOperationIntf {
	XAP_DAO_TRANS_SObjectListKeyEnum key;
	List<SObject> sObjectList;
	XAP_DAO_DML_InheritedSharingDml genericDml;
	XAP_DAO_TRANS_DmlResultFactory dmlResultFactory;

	public XAP_DAO_TRANS_SimpleUpserter(
			XAP_DAO_TRANS_SObjectListKeyEnum key,
			List<SObject> sObjectList,
			XAP_DAO_DML_InheritedSharingDml genericDml,
			XAP_DAO_TRANS_DmlResultFactory dmlResultFactory
	) {
		this.key = key;
		this.sObjectList = sObjectList;
		this.genericDml = genericDml;
		this.dmlResultFactory = dmlResultFactory;
	}

	public XAP_DAO_TRANS_SimpleUpserter(XAP_DAO_TRANS_SObjectListKeyEnum key, List<SObject> sObjectList) {
		this(
				key,
				sObjectList,
				XAP_DAO_DML_InheritedSharingDml.getInstance(),
				XAP_DAO_TRANS_DmlResultFactory.getInstance()
		);
	}

	public XAP_DAO_TRANS_SimpleUpserter(List<SObject> sObjectList) {
		this(XAP_DAO_TRANS_SObjectListKeyEnum.NO_CALLBACK_REQUIRED, sObjectList);
	}

	private XAP_DAO_DML_OperationModeEnum operationModeEnum = XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE;

	public XAP_DAO_TRANS_SimpleUpserter setOperationalMode(XAP_DAO_DML_OperationModeEnum operationModeEnum) {
		this.operationModeEnum = operationModeEnum;
		return this;
	}

	public XAP_DAO_TRANS_DmlResultIntf doDml(Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> prerequisitSObjectsByKeyMap) {
		Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> revisedSObjectListByKeyMap
				= new Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>>{this.key => this.sObjectList};

		return (this.sObjectList.isEmpty())
				? new XAP_DAO_TRANS_DmlPerfectSuccess(revisedSObjectListByKeyMap)
				: this.dmlResultFactory.createFor(
						revisedSObjectListByKeyMap,
						this.genericDml.doUpsert(this.sObjectList, this.operationModeEnum)
				);
	}
}
