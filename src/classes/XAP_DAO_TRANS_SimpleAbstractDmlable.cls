public abstract class XAP_DAO_TRANS_SimpleAbstractDmlable implements XAP_DAO_TRANS_DmlOperationIntf {
	XAP_DAO_TRANS_SObjectListKeyEnum key;
	List<SObject> sObjectList;
	protected XAP_DAO_DML_InheritedSharingDml genericDml;
	XAP_DAO_TRANS_DmlResultFactory dmlResultFactory;

	public XAP_DAO_TRANS_SimpleAbstractDmlable(
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

	public XAP_DAO_TRANS_SimpleAbstractDmlable(XAP_DAO_TRANS_SObjectListKeyEnum key, List<SObject> sObjectList) {
		this(
				key,
				sObjectList,
				XAP_DAO_DML_InheritedSharingDml.getInstance(),
				XAP_DAO_TRANS_DmlResultFactory.getInstance()
		);
	}

	public XAP_DAO_TRANS_SimpleAbstractDmlable(List<SObject> sObjectList) {
		this(XAP_DAO_TRANS_SObjectListKeyEnum.NO_CALLBACK_REQUIRED, sObjectList);
	}

	private XAP_DAO_DML_OperationModeEnum operationModeEnum = XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE;

	public XAP_DAO_TRANS_SimpleAbstractDmlable setOperationalMode(XAP_DAO_DML_OperationModeEnum operationModeEnum) {
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
						this.doDml(this.sObjectList, this.operationModeEnum)
				);
	}

	public abstract XAP_DAO_DML_ResultListWrapperIntf doDml(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationModeEnum);
}
