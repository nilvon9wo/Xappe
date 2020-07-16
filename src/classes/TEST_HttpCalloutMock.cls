@IsTest
global class TEST_HttpCalloutMock implements HttpCalloutMock {
	public HttpRequest receivedHttpRequest;
	public Exception thrownException;

	public HttpResponse returnedHttpResponse {
		get {
			if (this.returnedHttpResponse == null) {
				this.returnedHttpResponse = this.createDefaultSuccessResponse();
			}
			return this.returnedHttpResponse;
		}
		set;
	}

	global HttpResponse respond(HttpRequest request) {
		this.receivedHttpRequest = request;

		if (thrownException != null) {
			throw thrownException;
		}

		return this.returnedHttpResponse;
	}

	private HttpResponse createDefaultSuccessResponse() {
		HttpResponse testResponse = new HttpResponse();
		testResponse.setHeader('Content-Type', 'application/json');
		testResponse.setBody('{"example":"test"}');
		testResponse.setStatusCode(200);
		testResponse.setStatus('OK');
		return testResponse;
	}

}