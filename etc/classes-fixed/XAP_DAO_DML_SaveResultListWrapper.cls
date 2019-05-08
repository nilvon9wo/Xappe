public class XAP_DAO_DML_SaveResultListWrapper implements XAP_DAO_DML_ResultListWrapperIntf {
    @TestVisible private List<Database.SaveResult> saveResultList;
    @TestVisible private List<XAP_DAO_DML_SaveResultWrapper> resultWrapperList;

    public XAP_DAO_DML_SaveResultListWrapper(List<Database.SaveResult> saveResultList) {
        this.saveResultList = saveResultList;
    }

    public List<XAP_DAO_DML_SaveResultWrapper> getResultWrapperList() {
        if (this.resultWrapperList == null) {
            this.resultWrapperList = new List<XAP_DAO_DML_SaveResultWrapper>();
            for (Database.SaveResult saveResult : saveResultList) {
                resultWrapperList.add(new XAP_DAO_DML_SaveResultWrapper(saveResult));
            }
        }
        return this.resultWrapperList;
    }
}