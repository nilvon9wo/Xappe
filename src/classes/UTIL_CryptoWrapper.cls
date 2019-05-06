public virtual class UTIL_CryptoWrapper {
    public virtual Blob generateDigest(String algorithmName, Blob clearText) {
    	return Crypto.generateDigest(algorithmName, clearText);
    } 
}