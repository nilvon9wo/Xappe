@IsTest
public with sharing class XAP_HTTP_HttpMultiCalloutMock implements HttpCalloutMock {
    public List<HttpRequest> receivedRequestList = new List<HttpRequest>();
    public List<HttpResponse> returnedResponseList;
    public Integer requestCounter = 0;
    public HttpResponse respond(HttpRequest request) {
        this.receivedRequestList.add(request);
        return this.returnedResponseList[requestCounter++];
    }
}