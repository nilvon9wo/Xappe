global class IMCC_LoginDiscoveryHandler implements Auth.LoginDiscoveryHandler {
    DAO_AuthProviderSelector authProviderSelector;
    DAO_ThirdPartyAccountLinkSelector thirdPartyAccountLinkSelector;

    private IMCC_LoginDiscoveryHandler(
            DAO_AuthProviderSelector authProviderSelector,
            DAO_ThirdPartyAccountLinkSelector thirdPartyAccountLinkSelector
    ) {
        this.authProviderSelector = authProviderSelector;
        this.thirdPartyAccountLinkSelector = thirdPartyAccountLinkSelector;
    }

    public IMCC_LoginDiscoveryHandler() {
        this(DAO_AuthProviderSelector.getInstance(), DAO_ThirdPartyAccountLinkSelector.getInstance());
    }


    private static final List<Type> LOGIN_DISOCOVERY_EXPRESSION_TYPE_LIST = new List<Type>{
            IMCC_LoginDiscoveryByEmail.class,
            IMCC_LoginDiscoveryBySms.class
    };

    private static final String INVALID_IDENTIFIER = 'Invalid Identifier';
    private static final String NO_PASSWORDLESS_LOGIN = 'No Passwordless Login redirect URL returned for verification method: ';
    private static final String NO_VERIFICATION_METHOD_FOUND = 'No method found';

    global PageReference login(String identifier, String startUrl, Map<String, String> requestAttributes) {
        if (!String.isBlank(identifier)) {
            IMCC_UserWrapper userWrapper;
            Integer i = 0;
            while (userWrapper == null && i < LOGIN_DISOCOVERY_EXPRESSION_TYPE_LIST.size()) {
                userWrapper = ((IMCC_LoginDiscoveryIntf) LOGIN_DISOCOVERY_EXPRESSION_TYPE_LIST[i++].newInstance())
                        .searchForUser(identifier);
            }
            if (userWrapper != null) {
                return this.login(userWrapper, startUrl, requestAttributes);
            }
        }
        throw new Auth.LoginDiscoveryException(INVALID_IDENTIFIER);
    }

    private PageReference login(IMCC_UserWrapper userWrapper, String startUrl, Map<String, String> requestAttributes) {
        PageReference redirect = this.getSsoRedirect(userWrapper.user);
        if (redirect == null) {
            redirect = this.getVerificationRedirect(userWrapper, redirect, startUrl);
        }
        return redirect;
    }

    private PageReference getVerificationRedirect(IMCC_UserWrapper userWrapper, PageReference redirect, String startUrl) {
        Boolean hasVerificationMethod = userWrapper.verificationMethod != null;
        if (hasVerificationMethod) {
            List<Auth.VerificationMethod> methods = new List<Auth.VerificationMethod>{
                    userWrapper.verificationMethod
            };
            redirect = Site.passwordlessLogin(userWrapper.user.Id, methods, startUrl);
        }

        if (redirect == null) {
            String error = hasVerificationMethod
                    ? NO_PASSWORDLESS_LOGIN + userWrapper.verificationMethod
                    : NO_VERIFICATION_METHOD_FOUND;
            throw new Auth.LoginDiscoveryException(NO_PASSWORDLESS_LOGIN + userWrapper.verificationMethod);
        }

        return redirect;
    }

    private PageReference getSsoRedirect(User user) {
        Set<String> emailSet = new Set<String>{
                user.Email
        };

        String provider = this.thirdPartyAccountLinkSelector
                .selectByHandle(emailSet)[0]
                .Provider;

        List<AuthProvider> authProviderList = this.authProviderSelector.selectByDeveloperName(
                new Set<String>{
                        provider
                }
        );

        return (!authProviderList.isEmpty())
                ? new PageReference(authProviderList[0].SsoKickoffUrl)
                : null;
    }
}