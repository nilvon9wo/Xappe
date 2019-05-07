public virtual class UTIL_CryptoSha2Helper {
    UTIL_CryptoWrapper cryptoWrapper;

    public UTIL_CryptoSha2Helper(UTIL_CryptoWrapper cryptoWrapper) {
        this.cryptoWrapper = cryptoWrapper;
    }

    public UTIL_CryptoSha2Helper() {
        this(new UTIL_CryptoWrapper());
    }

    private static final String ALGORITHM_NAME = 'SHA-512';

    public virtual Blob encrypt(String clearText) {
        return this.cryptoWrapper.generateDigest(ALGORITHM_NAME, Blob.valueOf(clearText));
    }
}