public with sharing class DAP_DummyApiProxyService {
    private final DAP_DummyApiClient dummyApiClient;
    private DAP_DummyApiProxyService(DAP_DummyApiClient dummyApiClient) {
        this.dummyApiClient = dummyApiClient;
    }

    private DAP_DummyApiProxyService() {
        this(DAP_DummyApiClient.getInstance());
    }

    private static DAP_DummyApiProxyService INSTANCE;
    public static DAP_DummyApiProxyService getInstance(){
        if (INSTANCE == null) {
            INSTANCE = new DAP_DummyApiProxyService();
        }

        return INSTANCE;
    }

    public List<DAP_UserOutputDto> getDummyApiUsers() {
        DAP_UserDataEnvelope response = this.dummyApiClient.getUsers();
        return convertUsers(response.users);
    }

    //noinspection ApexMethodCanBeStatic
    private List<DAP_UserOutputDto> convertUsers(List<DAP_UserInputDto> inputUsers) {
        List<DAP_UserOutputDto> outputUsers = new List<DAP_UserOutputDto>();
        for (DAP_UserInputDto inputDto : inputUsers) {
            outputUsers.add(inputDto.toOutputDto());
        }

        return outputUsers;
    }
}