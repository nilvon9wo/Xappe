public virtual class XAP_DAO_TransactionHelper {
    public virtual Savepoint createSavePoint() {
        return Database.setSavepoint();
    }

    public virtual void rollback(Savepoint savePoint) {
        Database.rollback(savePoint);
    }
}