public virtual class XAP_REST_RestClient {
    protected XAP_REST_RestClient() {
    }

    private static XAP_REST_RestClient instance;
    public static XAP_REST_RestClient getInstance() {
        if (instance == null) {
            instance = new XAP_REST_RestClient();
        }
        return instance;
    }
    public virtual HttpResponse makeApiCall(XAP_REST_RestRequest restRequest) {
        return new Http()
                .send(restRequest.toHttpRequest());
    }

    public virtual HttpResponse del(XAP_REST_RestRequest restRequest) {
        restRequest.setMethod(XAP_REST_HttpVerb.DEL);
        return this.makeApiCall(restRequest);
    }

    public virtual HttpResponse get(XAP_REST_RestRequest restRequest) {
        restRequest.setMethod(XAP_REST_HttpVerb.GET);
        return this.makeApiCall(restRequest);
    }

    public virtual HttpResponse patch(XAP_REST_RestRequest restRequest) {
        restRequest.setMethod(XAP_REST_HttpVerb.PATCH);
        return this.makeApiCall(restRequest);
    }

    public virtual HttpResponse post(XAP_REST_RestRequest restRequest) {
        restRequest.setMethod(XAP_REST_HttpVerb.POST);
        return this.makeApiCall(restRequest);
    }

    public virtual HttpResponse put(XAP_REST_RestRequest restRequest) {
        restRequest.setMethod(XAP_REST_HttpVerb.PUT);
        return this.makeApiCall(restRequest);
    }
}
