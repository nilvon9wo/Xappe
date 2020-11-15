@IsTest
public with sharing class XAP_HTTP_HttpSingleCalloutMock implements HttpCalloutMock {
    public static final Integer STATUS_OK_CODE = 200;
    public static final String STATUS_OK = 'OK';

    public HttpRequest receivedRequest;
    public Exception thrownException;
    public HttpResponse returnedResponse = this.createDefaultResponse();
    public HttpResponse respond(HttpRequest request) {
        this.receivedRequest = request;

        if (thrownException != null) {
            throw thrownException;
        }

        return this.returnedResponse;
    }

    public HttpResponse createDefaultResponse() {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(STATUS_OK_CODE);
        response.setStatus(STATUS_OK);
        response.setBody('');
        return response;
    }
}
