public with sharing class XAP_ENV_UrlWrapper {
    public XAP_ENV_UrlWrapper() {
        this.hostUrl = Url.getOrgDomainUrl()
                .toString();
    }

    public String hostUrl;
}