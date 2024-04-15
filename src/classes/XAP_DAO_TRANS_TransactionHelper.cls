public virtual class XAP_DAO_TRANS_TransactionHelper {
    @TestVisible
    protected XAP_DAO_TRANS_TransactionHelper() {
    }

    private static XAP_DAO_TRANS_TransactionHelper instance;

    public static XAP_DAO_TRANS_TransactionHelper getInstance() {
        if (instance == null) {
            instance = new XAP_DAO_TRANS_TransactionHelper();
        }
        return instance;
    }

    public virtual Savepoint createSavePoint() {
        return Database.setSavepoint();
    }

    //noinspection ApexUnusedDeclaration
    public virtual void rollback(Savepoint savePoint, Exception dmlFailure) {
        // TODO: DO something with dmlFailure data.
        rollback(savePoint);
    }

    public virtual void rollback(Savepoint savePoint) {
        Database.rollback(savePoint);
    }
}