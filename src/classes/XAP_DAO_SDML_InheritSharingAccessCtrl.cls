public class XAP_DAO_SDML_InheritSharingAccessCtrl extends XAP_DAO_SDML_AbsInternalAccessCtrl {
    private void dbInsert(SObject obj) {
        insert obj;
    }
    private Database.SaveResult[] dbInsert(SObject [] objs) {
        return Database.insert(objs, arrayAllOrNoneParam);
    }
    private void dbUpdate(SObject obj) {
        update obj;
    }
    private Database.SaveResult[] dbUpdate(SObject [] objs) {
        return Database.update(objs, arrayAllOrNoneParam);
    }
    private void dbDelete(SObject obj) {
        delete obj;
    }
    private Database.DeleteResult[] dbDelete(SObject [] objs) {
        return Database.delete(objs, arrayAllOrNoneParam);
    }
}