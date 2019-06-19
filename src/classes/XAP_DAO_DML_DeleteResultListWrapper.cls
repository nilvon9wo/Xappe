public class XAP_DAO_DML_DeleteResultListWrapper extends XAP_DAO_DML_ResultListWrapperAbs {
	@TestVisible private List<Database.DeleteResult> deleteResultList;
	@TestVisible private List<XAP_DAO_DML_DeleteResultWrapper> resultWrapperList;

	public XAP_DAO_DML_DeleteResultListWrapper(List<Database.DeleteResult> deleteResultList) {
		this.deleteResultList = deleteResultList;
	}

	public override List<XAP_DAO_DML_ResultWrapperIntf> getResultWrapperList() {
		if (this.resultWrapperList == null) {
			this.resultWrapperList = new List<XAP_DAO_DML_DeleteResultWrapper>();
			for (Database.DeleteResult deleteResult : deleteResultList) {
				resultWrapperList.add(new XAP_DAO_DML_DeleteResultWrapper(deleteResult));
			}
		}
		return this.resultWrapperList;
	}
}