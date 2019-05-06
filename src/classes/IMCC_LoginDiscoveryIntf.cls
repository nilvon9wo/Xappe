public interface IMCC_LoginDiscoveryIntf {
    IMCC_UserWrapper searchForUser(String value);
    List<User> selectUsers(Set<String> valueSet);
    Auth.VerificationMethod getVerificationMethod();
}