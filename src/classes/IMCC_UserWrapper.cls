public class IMCC_UserWrapper {
    public User user { get; private set; }
    public Auth.VerificationMethod verificationMethod { get; private set; }

    public IMCC_UserWrapper(User user, Auth.VerificationMethod verificationMethod) {
        this.user = user;
        this.verificationMethod = verificationMethod;
    }
}