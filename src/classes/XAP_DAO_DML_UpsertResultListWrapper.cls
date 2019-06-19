public class XAP_DAO_DML_UpsertResultListWrapper extends XAP_DAO_DML_ResultListWrapperAbs {
	@TestVisible private List<Database.UpsertResult> upsertResultList;
	@TestVisible private List<XAP_DAO_DML_UpsertResultWrapper> resultWrapperList;

	public XAP_DAO_DML_UpsertResultListWrapper(List<Database.UpsertResult> upsertResultList) {
		this.upsertResultList = upsertResultList;
	}

	public override List<XAP_DAO_DML_ResultWrapperIntf> getResultWrapperList() {
		if (this.resultWrapperList == null) {
			this.resultWrapperList = new List<XAP_DAO_DML_UpsertResultWrapper>();
			for (Database.UpsertResult upsertResult : upsertResultList) {
				resultWrapperList.add(new XAP_DAO_DML_UpsertResultWrapper(upsertResult));
			}
		}
		return this.resultWrapperList;
	}
}