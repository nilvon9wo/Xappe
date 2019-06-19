public class XAP_DAO_DML_UndeleteResultListWrapper extends XAP_DAO_DML_ResultListWrapperAbs {
	@TestVisible private List<Database.UndeleteResult> undeleteResultList;
	@TestVisible private List<XAP_DAO_DML_UndeleteResultWrapper> resultWrapperList;

	public XAP_DAO_DML_UndeleteResultListWrapper(List<Database.UndeleteResult> undeleteResultList) {
		this.undeleteResultList = undeleteResultList;
	}

	public override List<XAP_DAO_DML_ResultWrapperIntf> getResultWrapperList() {
		if (this.resultWrapperList == null) {
			this.resultWrapperList = new List<XAP_DAO_DML_UndeleteResultWrapper>();
			for (Database.UndeleteResult undeleteResult : undeleteResultList) {
				resultWrapperList.add(new XAP_DAO_DML_UndeleteResultWrapper(undeleteResult));
			}
		}
		return this.resultWrapperList;
	}
}