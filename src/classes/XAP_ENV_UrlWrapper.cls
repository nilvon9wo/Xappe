public with sharing class XAP_ENV_UrlWrapper {
    public XAP_ENV_UrlWrapper() {
        this.hostUrl = Url.getSalesforceBaseUrl().getHost();
    }

    public String hostUrl;
}