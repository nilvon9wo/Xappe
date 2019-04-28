public class XAP_DML_UndeleteResultListWrapper implements XAP_DML_ResultListWrapperIntf {
    @TestVisible private List<Database.UndeleteResult> undeleteResultList;
    @TestVisible private List<XAP_DML_UndeleteResultWrapper> resultWrapperList;

    public XAP_DML_UndeleteResultListWrapper(List<Database.UndeleteResult> undeleteResultList) {
        this.undeleteResultList = undeleteResultList;
    }

    public List<XAP_DML_UndeleteResultWrapper> getResultWrapperList() {
        if (this.resultWrapperList == null) {
            this.resultWrapperList = new List<XAP_DML_UndeleteResultWrapper>();
            for (Database.UndeleteResult undeleteResult : undeleteResultList) {
                resultWrapperList.add(new XAP_DML_UndeleteResultWrapper(undeleteResult));
            }
        }
        return this.resultWrapperList;
    }
}