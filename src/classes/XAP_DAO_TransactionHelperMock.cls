@IsTest
public class XAP_DAO_TransactionHelperMock extends XAP_DAO_TransactionHelper {
	public Savepoint receivedSavePoint;
    public override void rollback(Savepoint savePoint) {
    	this.receivedSavePoint = savePoint;
    }
}