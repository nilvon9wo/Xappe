public class XAP_DML_DeleteResultListWrapper implements XAP_DML_ResultListWrapperIntf {
    @TestVisible private List<Database.DeleteResult> deleteResultList;
    @TestVisible private List<XAP_DML_DeleteResultWrapper> resultWrapperList;

    public XAP_DML_DeleteResultListWrapper(List<Database.DeleteResult> deleteResultList) {
        this.deleteResultList = deleteResultList;
    }

    public List<XAP_DML_DeleteResultWrapper> getResultWrapperList() {
        if (this.resultWrapperList == null) {
            this.resultWrapperList = new List<XAP_DML_DeleteResultWrapper>();
            for (Database.DeleteResult deleteResult : deleteResultList) {
                resultWrapperList.add(new XAP_DML_DeleteResultWrapper(deleteResult));
            }
        }
        return this.resultWrapperList;
    }
}