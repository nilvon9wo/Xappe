public virtual class XAP_DAO_BatchableHelper {
    public virtual Id execute(Database.Batchable<SObject> batchable) {
      	return Database.executeBatch(batchable); 
    }
}