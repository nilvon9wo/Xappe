public virtual class XAP_REST_ResponseWrapper {
	XAP_ENC_EncodingUtilWrapper encodingUtilWrapper;
	XAP_UTIL_JsonHelper jsonHelper;
	
	@TestVisible public Map<String, String> headers {get; private set;}
	@TestVisible public String httpMethod {get; private set;}
	@TestVisible public Map<String, String> params {get; private set;}
	@TestVisible public String remoteIpAddress {get; private set;}
	@TestVisible public Blob requestBody {get; private set;}
	@TestVisible public String requestURI {get; private set;}
	@TestVisible public String resourcePath {get; private set;}
	
	public XAP_REST_ResponseWrapper(XAP_ENC_EncodingUtilWrapper encodingUtilWrapper, XAP_UTIL_JsonHelper jsonHelper) {
		this.encodingUtilWrapper = encodingUtilWrapper;
		this.jsonHelper = jsonHelper;
		
		RestRequest request = RestContext.request; 
		if (request != null) {
			this.headers = request.headers;
			this.httpMethod = request.httpMethod;
			this.params = request.params;
			this.remoteIpAddress = request.remoteAddress;
			this.requestBody = request.requestBody;
			this.requestURI = request.requestURI;
			this.resourcePath = request.resourcePath;
		}
	}
	
	public XAP_REST_ResponseWrapper() {
		this(new XAP_ENC_EncodingUtilWrapper(), new XAP_UTIL_JsonHelper());
	}
	
	public XAP_REST_Request__c exportAsRecord() {
		XAP_REST_Request__c request =  new XAP_REST_Request__c(
			Headers__c = this.jsonHelper.serialize(this.headers),
			Http_Method__c = this.httpMethod,
			Params__c = this.jsonHelper.serialize(this.params),
			Remote_IP_Address__c = this.remoteIpAddress,
			Request_URI__c = this.requestURI,
			Resource_Path__c = this.resourcePath
		);
		if (this.requestBody != null) {
			request.Request_Body__c = this.encodingUtilWrapper.base64Encode(this.requestBody);
		}
		return request;
	}
}