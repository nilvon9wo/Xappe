public class XAP_DAO_TRANS_SimpleDelete implements XAP_DAO_TRANS_DmlOperationIntf {
    String key;
    List<SObject> sObjectList;
    XAP_DAO_DML_GenericDml genericDml;
    XAP_DAO_TRANS_DmlResultFactory dmlResultFactory;

    public XAP_DAO_TRANS_SimpleDelete(
            String key,
            List<SObject> sObjectList,
            XAP_DAO_DML_GenericDml genericDml,
            XAP_DAO_TRANS_DmlResultFactory dmlResultFactory
    ) {
        this.key = key;
        this.sObjectList = sObjectList;
        this.genericDml = genericDml;
        this.dmlResultFactory = dmlResultFactory;
    }

    public XAP_DAO_TRANS_SimpleDelete(String key, List<SObject> sObjectList) {
        this(
                key,
                sObjectList,
                XAP_DAO_DML_GenericDml.getInstance(),
                XAP_DAO_TRANS_DmlResultFactory.getInstance()
        );
    }

    public XAP_DAO_TRANS_DmlResultIntf doDml(Map<String, List<SObject>> prerequisitSObjectsByKeyMap) {
        return this.dmlResultFactory.createFor(
                new Map<String, List<SObject>>{this.key => this.sObjectList},
                this.genericDml.doDelete(this.sObjectList, XAP_DAO_DML_GenericDml.NOT_ALL_OR_NONE)
        );
    }
}