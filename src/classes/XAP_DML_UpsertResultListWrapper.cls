public class XAP_DML_UpsertResultListWrapper implements XAP_DML_ResultListWrapperIntf {
    @TestVisible private List<Database.UpsertResult> upsertResultList;
    @TestVisible private List<XAP_DML_UpsertResultWrapper> resultWrapperList;

    public XAP_DML_UpsertResultListWrapper(List<Database.UpsertResult> upsertResultList) {
        this.upsertResultList = upsertResultList;
    }

    public List<XAP_DML_UpsertResultWrapper> getResultWrapperList() {
        if (this.resultWrapperList == null) {
            this.resultWrapperList = new List<XAP_DML_UpsertResultWrapper>();
            for (Database.UpsertResult upsertResult : upsertResultList) {
                resultWrapperList.add(new XAP_DML_UpsertResultWrapper(upsertResult));
            }
        }
        return this.resultWrapperList;
    }
}