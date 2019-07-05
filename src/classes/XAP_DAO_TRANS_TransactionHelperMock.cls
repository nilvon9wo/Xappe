@IsTest
public class XAP_DAO_TRANS_TransactionHelperMock extends XAP_DAO_TRANS_TransactionHelper {
	public Savepoint returnedSavePoint;
	public override Savepoint createSavePoint() {
		return this.returnedSavePoint;
	}

	public Savepoint receivedSavePoint;
	public override void rollback(Savepoint savePoint) {
		this.receivedSavePoint = savePoint;
	}
}
