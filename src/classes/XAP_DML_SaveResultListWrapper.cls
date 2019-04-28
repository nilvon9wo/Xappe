public class XAP_DML_SaveResultListWrapper implements XAP_DML_ResultListWrapperIntf {
    @TestVisible private List<Database.SaveResult> saveResultList;
    @TestVisible private List<XAP_DML_SaveResultWrapper> resultWrapperList;

    public XAP_DML_SaveResultListWrapper(List<Database.SaveResult> saveResultList) {
        this.saveResultList = saveResultList;
    }

    public List<XAP_DML_SaveResultWrapper> getResultWrapperList() {
        if (this.resultWrapperList == null) {
            this.resultWrapperList = new List<XAP_DML_SaveResultWrapper>();
            for (Database.SaveResult saveResult : saveResultList) {
                resultWrapperList.add(new XAP_DML_SaveResultWrapper(saveResult));
            }
        }
        return this.resultWrapperList;
    }
}