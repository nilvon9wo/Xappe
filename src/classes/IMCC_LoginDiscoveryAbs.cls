public abstract class IMCC_LoginDiscoveryAbs implements IMCC_LoginDiscoveryIntf {
    DAO_TwoFactorMethodsInfoSelector twoFactorMethodsInfo;
    protected DAO_UserSelector userSelector;

    private IMCC_LoginDiscoveryAbs(
            DAO_TwoFactorMethodsInfoSelector twoFactorMethodsInfo,
            DAO_UserSelector userSelector
    ) {
        this.twoFactorMethodsInfo = twoFactorMethodsInfo;
        this.userSelector = userSelector;
    }

    public IMCC_LoginDiscoveryAbs() {
        this(DAO_TwoFactorMethodsInfoSelector.getInstance(), DAO_UserSelector.getInstance());
    }

    private static final String NO_UNIQUE_USER_FOUND = 'No unique user found. User count=';

    public virtual IMCC_UserWrapper searchForUser(String value) {
        List<User> userList = this.selectUsers(new Set<String>{
                value
        });
        if (!userList.isEmpty() && userList.size() == 1) {
            User user = userList[0];
            List<TwoFactorMethodsInfo> verifiedInfo = this.twoFactorMethodsInfo.selectByUserId(new Set<Id>{
                    user.Id
            });

            Auth.VerificationMethod verificationMethod = (!verifiedInfo.isEmpty() && verifiedInfo[0].HasUserVerifiedEmailAddress)
                    ? this.getVerificationMethod()
                    : Auth.VerificationMethod.PASSWORD;

            return new IMCC_UserWrapper(user, verificationMethod);
        } else {
            throw new Auth.LoginDiscoveryException(NO_UNIQUE_USER_FOUND + userList.size());
        }
    }

    public abstract List<User> selectUsers(Set<String> valueSet);
    public abstract Auth.VerificationMethod getVerificationMethod();
}