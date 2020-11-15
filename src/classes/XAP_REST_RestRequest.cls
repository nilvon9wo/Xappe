public with sharing class XAP_REST_RestRequest {
    private static final Set<XAP_REST_HttpVerb> METHODS_WITH_BODY_SET = new Set<XAP_REST_HttpVerb>{
            XAP_REST_HttpVerb.PATCH,
            XAP_REST_HttpVerb.POST,
            XAP_REST_HttpVerb.PUT
    };

    @TestVisible
    private static final Map<String, String> DEFAULT_HEADER_VALUE_BY_KEY_MAP = new Map<String, String>{
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
    };

    @TestVisible
    public String endPoint { get; private set; }
    public XAP_REST_RestRequest setEndPoint(String value) {
        this.endPoint = value;
        return this;
    }

    @TestVisible
    public String namedCredential { get; private set; }
    public XAP_REST_RestRequest setNamedCredential(String value) {
        this.namedCredential = value;
        return this;
    }

    public XAP_REST_HttpVerb method {
        get {
            return (method != null)
                    ? this.method
                    : XAP_REST_HttpVerb.GET;
        }
        private set;
    }
    public XAP_REST_RestRequest setMethod(XAP_REST_HttpVerb value) {
        this.method = value;
        return this;
    }

    public String path {
        get {
            return (path != null)
                    ? this.path
                    : '/';
        }
        private set;
    }
    public XAP_REST_RestRequest setPath(String value) {
        this.path = value;
        return this;
    }

    public String query {
        get {
            return (query != null)
                    ? this.query
                    : '';
        }
        private set;
    }
    public XAP_REST_RestRequest setQuery(String value) {
        this.query = value;
        return this;
    }

    public String body {
        get {
            return (body != null)
                    ? this.body
                    : '';
        }
        private set;
    }
    public XAP_REST_RestRequest setBody(String value) {
        this.body = value;
        return this;
    }

    public Map<String, String> headers {
        get {
            return (headers != null)
                    ? this.headers
                    : DEFAULT_HEADER_VALUE_BY_KEY_MAP;
        }
        private set;
    }
    public XAP_REST_RestRequest setHeaders(Map<String, String> value) {
        this.headers = value;
        return this;
    }

    private HttpRequest httpRequest = new HttpRequest();
    public HttpRequest toHttpRequest() {
        return this.setEndPoint()
                .setRequestHeaders()
                .setMethod()
                .setBody()
                .httpRequest;
    }

    private XAP_REST_RestRequest setEndPoint() {
        if (!String.isBlank(this.endPoint) && !String.isBlank(this.namedCredential)) {
            throw new XAP_REST_RestRequestException('Ambiguous request: both endPoint and namedCredential have been set.');
        }

        String encodedQuery = EncodingUtil.urlEncode(this.query, 'UTF-8');
        if (this.method == XAP_REST_HttpVerb.PATCH) {
            encodedQuery += '?_HttpMethod=PATCH';
        }
        String endPoint = !String.isBlank(this.endPoint)
                ? this.endPoint
                : this.createEndPoint(encodedQuery);

        this.httpRequest.setEndpoint(endPoint);
        return this;
    }

    private String createEndPoint(String encodedQuery) {
        return 'callout:' +
                this.namedCredential +
                this.ensureStringEndsInSlash(this.path) +
                encodedQuery;
    }

    private XAP_REST_RestRequest setRequestHeaders() {
        for (String header : this.headers.keySet()) {
            this.httpRequest.setHeader(header, this.headers.get(header));
        }
        return this;
    }


    private XAP_REST_RestRequest setMethod() {
        String verb;
        switch on this.method {
            when DEL {
                verb = 'DELETE';
            }
            when PATCH {
                verb = 'POST';
            }
            when else {
                verb = String.valueOf(this.method);
            }
        }
        this.httpRequest.setMethod(verb);
        return this;
    }

    private XAP_REST_RestRequest setBody() {
        if (
                String.isNotBlank(this.body)
                        && METHODS_WITH_BODY_SET.contains(this.method)
                ) {
            this.httpRequest.setBody(this.body);
        }
        return this;
    }

    @TestVisible
    private String ensureStringEndsInSlash(String resource) {
        return (resource.endsWith('/'))
                ? resource
                : resource + '/';
    }

}