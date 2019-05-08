public class IMCC_LoginDiscoveryByEmail extends IMCC_LoginDiscoveryAbs {
    private static final String EMAIL_PATTERN = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';

    public override IMCC_UserWrapper searchForUser(String value) {
        return (this.isValidEmail(value))
                ? super.searchForUser(value)
                : null;
    }

    private Boolean isValidEmail(String identifier) {
        return Pattern.compile(EMAIL_PATTERN)
                .matcher(identifier)
                .matches();
    }

    public override List<User> selectUsers(Set<String> valueSet) {
        return super.userSelector.selectByEmail(valueSet);
    }

    public override Auth.VerificationMethod getVerificationMethod() {
        return Auth.VerificationMethod.EMAIL;
    }
}