public virtual class XAP_ENC_EncodingUtilWrapper {
	private static final String DEFAULT_URL_ENCODING_SCHEME = 'UTF-8';

    public virtual Blob base64Decode(String value) {
    	return EncodingUtil.base64Decode(value);
    }
	
    public virtual String base64Encode(Blob value) {
    	return EncodingUtil.base64Encode(value);
    }

    public virtual String urlDecode(String value) {
    	return EncodingUtil.urlDecode(value, DEFAULT_URL_ENCODING_SCHEME);
    }
    
    public virtual String urlEncode(String value) {
    	return EncodingUtil.urlEncode(value, DEFAULT_URL_ENCODING_SCHEME);
    }
}