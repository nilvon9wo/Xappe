public class XAP_DAO_TRANS_SimpleUpsert implements XAP_DAO_TRANS_DmlOperationIntf {
    String key;
    List<SObject> sObjectList;
    XAP_DAO_DML_InheritedSharingDml genericDml;
    XAP_DAO_TRANS_DmlResultFactory dmlResultFactory;

    public XAP_DAO_TRANS_SimpleUpsert(
            String key,
            List<SObject> sObjectList,
            XAP_DAO_DML_InheritedSharingDml genericDml,
            XAP_DAO_TRANS_DmlResultFactory dmlResultFactory
    ) {
        this.key = key;
        this.sObjectList = sObjectList;
        this.genericDml = genericDml;
        this.dmlResultFactory = dmlResultFactory;
    }

    public XAP_DAO_TRANS_SimpleUpsert(String key, List<SObject> sObjectList) {
        this(
                key,
                sObjectList,
                XAP_DAO_DML_InheritedSharingDml.getInstance(),
                XAP_DAO_TRANS_DmlResultFactory.getInstance()
        );
    }

    private XAP_DAO_DML_OperationModeEnum operationModeEnum = XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE;

    public XAP_DAO_TRANS_SimpleUpsert setOperationalMode(XAP_DAO_DML_OperationModeEnum operationModeEnum) {
        this.operationModeEnum = operationModeEnum;
        return this;
    }

    public XAP_DAO_TRANS_DmlResultIntf doDml(Map<String, List<SObject>> prerequisitSObjectsByKeyMap) {
        Map<String, List<SObject>> revisedSObjectListByKeyMap
                = new Map<String, List<SObject>>{this.key => this.sObjectList};

        return (this.sObjectList.isEmpty())
                ? new XAP_DAO_TRANS_DmlPerfectSuccess(revisedSObjectListByKeyMap)
                : this.dmlResultFactory.createFor(
                        revisedSObjectListByKeyMap,
                        this.genericDml.doUpsert(this.sObjectList, this.operationModeEnum)
                );
    }
}
