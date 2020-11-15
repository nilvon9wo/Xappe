@IsTest
public with sharing class XAP_HTTP_HttpHelperMock extends XAP_HTTP_HttpHelper {
    public Map<String, String> receivedValueByKeyMap;
    public String returnedFormPayload;
    public override String createFormPayload(Map<String, String> valueByKeyMap) {
        this.receivedValueByKeyMap = valueByKeyMap;
        return this.returnedFormPayload;
    }

    public HttpResponse receivedHttpResponse;
    public Boolean returnedWasFailure;
    public override Boolean isFailure(HttpResponse response) {
        this.receivedHttpResponse = response;
        return this.returnedWasFailure;
    }
}