public class XAP_DAO_DML_SaveResultListWrapper extends XAP_DAO_DML_ResultListWrapperAbs {
	@TestVisible private List<Database.SaveResult> saveResultList;
	@TestVisible private List<XAP_DAO_DML_SaveResultWrapper> resultWrapperList;

	public XAP_DAO_DML_SaveResultListWrapper(List<Database.SaveResult> saveResultList) {
		this.saveResultList = saveResultList;
	}

	public override List<XAP_DAO_DML_ResultWrapperIntf> getResultWrapperList() {
		if (this.resultWrapperList == null) {
			this.resultWrapperList = new List<XAP_DAO_DML_SaveResultWrapper>();
			for (Database.SaveResult saveResult : saveResultList) {
				resultWrapperList.add(new XAP_DAO_DML_SaveResultWrapper(saveResult));
			}
		}
		return this.resultWrapperList;
	}
}