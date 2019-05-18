public interface XAP_DAO_TRANS_DmlResultIntf {
    Map<String, List<SObject>> getResultSObjectsByKeyMap();
    XAP_DAO_DML_SuccessLevelEnum getSuccessLevel();
}