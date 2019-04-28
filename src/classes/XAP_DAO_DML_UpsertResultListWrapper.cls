public class XAP_DAO_DML_UpsertResultListWrapper implements XAP_DAO_DML_ResultListWrapperIntf {
    @TestVisible private List<Database.UpsertResult> upsertResultList;
    @TestVisible private List<XAP_DAO_DML_UpsertResultWrapper> resultWrapperList;

    public XAP_DAO_DML_UpsertResultListWrapper(List<Database.UpsertResult> upsertResultList) {
        this.upsertResultList = upsertResultList;
    }

    public List<XAP_DAO_DML_UpsertResultWrapper> getResultWrapperList() {
        if (this.resultWrapperList == null) {
            this.resultWrapperList = new List<XAP_DAO_DML_UpsertResultWrapper>();
            for (Database.UpsertResult upsertResult : upsertResultList) {
                resultWrapperList.add(new XAP_DAO_DML_UpsertResultWrapper(upsertResult));
            }
        }
        return this.resultWrapperList;
    }
}