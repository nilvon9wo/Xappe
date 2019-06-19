public class XAP_DAO_DML_DatabaseErrorRewrapper {
	public List<XAP_DAO_DML_DatabaseErrorWrapper> convert(List<Database.Error> errorList) {
		List<XAP_DAO_DML_DatabaseErrorWrapper> wrapperList = new List<XAP_DAO_DML_DatabaseErrorWrapper>();
		if (errorList != null) {
			for (Database.Error error : errorList) {
				wrapperList.add(new XAP_DAO_DML_DatabaseErrorWrapper(error));
			}
		}
		return wrapperList;
	}
}