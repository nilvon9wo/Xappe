public virtual class UTIL_CryptoSaltFactory {
    XAP_UTIL_Randomizer randomizer;

    public UTIL_CryptoSaltFactory(XAP_UTIL_Randomizer randomizer) {
        this.randomizer = randomizer;
    }

    public UTIL_CryptoSaltFactory() {
        this(new XAP_UTIL_Randomizer());
    }

    private static final Integer SALT_LENGTH = 8;

    public String create() {
        return this.randomizer.getRandomString(SALT_LENGTH);
    }
}