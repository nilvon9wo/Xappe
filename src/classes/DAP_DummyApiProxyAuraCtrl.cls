public with sharing class DAP_DummyApiProxyAuraCtrl {
    private final DAP_DummyApiProxyService dummyApiProxyService;

    private DAP_DummyApiProxyAuraCtrl(DAP_DummyApiProxyService dummyApiProxyService) {
        this.dummyApiProxyService = dummyApiProxyService;
    }

    private DAP_DummyApiProxyAuraCtrl() {
        this(DAP_DummyApiProxyService.getInstance());
    }

    private static DAP_DummyApiProxyAuraCtrl INSTANCE;
    public static DAP_DummyApiProxyAuraCtrl getInstance(){
        if (INSTANCE == null) {
            INSTANCE = new DAP_DummyApiProxyAuraCtrl();
        }

        return INSTANCE;
    }

    @AuraEnabled
    public static List<DAP_UserOutputDto> getDummyApiUsers() {
        return getInstance()
                .dummyApiProxyService.getDummyApiUsers();
    }
}