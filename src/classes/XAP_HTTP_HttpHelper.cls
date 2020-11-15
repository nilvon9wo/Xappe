public with sharing virtual class XAP_HTTP_HttpHelper {
    protected XAP_HTTP_HttpHelper() {
    }

    private static XAP_HTTP_HttpHelper instance;
    public static XAP_HTTP_HttpHelper getInstance() {
        if (instance == null) {
            instance = new XAP_HTTP_HttpHelper();
        }
        return instance;
    }

    public virtual String createFormPayload(Map<String, String> valueByKeyMap) {
        List<String> pairList = new List<String>();
        for (String key : valueByKeyMap.keySet()) {
            pairList.add(this.encodeForPayload(key, valueByKeyMap.get(key)));
        }
        return String.join(pairList, '&');
    }

    @TestVisible
    private virtual String encodeForPayload(String key, String value) {
        return key + '=' + EncodingUtil.urlEncode(value,'UTF-8');
    }

    public virtual Boolean isSuccess(HttpResponse response) {
        return !this.isFailure(response);
    }

    public virtual Boolean isFailure(HttpResponse response) {
        if (response == null) {
            return true;
        }

        Integer statusCode = response.getStatusCode();
        return statusCode < 200
                || statusCode > 299;
    }
}