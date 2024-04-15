public with sharing class DAP_DummyApiClientUserRequestFty {
    private final DAO_DummyApiSettingsSelector dummyApiSettingsSelector;

    private DAP_DummyApiClientUserRequestFty(
            DAO_DummyApiSettingsSelector dummyApiSettingsSelector
        )
    {
        this.dummyApiSettingsSelector = dummyApiSettingsSelector;
    }

    private DAP_DummyApiClientUserRequestFty()
    {
        this(DAO_DummyApiSettingsSelector.getInstance());
    }

    private static DAP_DummyApiClientUserRequestFty INSTANCE;
    public static DAP_DummyApiClientUserRequestFty getInstance(){
        if (INSTANCE == null) {
            INSTANCE = new DAP_DummyApiClientUserRequestFty();
        }

        return INSTANCE;
    }

    public HttpRequest create() {
        HttpRequest request = new HttpRequest();
        String path = createPathFor();
        request.setEndpoint('callout:Dummy_Api_Named_Credential' + path );
        request.setMethod('GET');
        return request;
    }

    //noinspection ApexMethodCanBeStatic
    private String createPathFor() {
        Dummy_Api_Settings__c apiSettings = this.dummyApiSettingsSelector.selectInstance();
        String path = '/data/v1/user';
        path += '?limit=' + apiSettings.Default_Page_Limit__c;
        return path;
    }
}