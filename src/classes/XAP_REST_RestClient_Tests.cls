@IsTest
private inherited sharing class XAP_REST_RestClient_Tests {
    private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
    private static final XAP_REST_RestClient CLIENT_UNDER_TEST = XAP_REST_RestClient.getInstance();
    private static final XAP_HTTP_HttpSingleCalloutMock MOCK_CALLOUT = new XAP_HTTP_HttpSingleCalloutMock();

    @IsTest
    static void testStaticMakeApiCallFullParamsPositive() {
        // Arrange
        prepCalloutMock();
        XAP_REST_RestRequest testRequest = new XAP_REST_RestRequest()
                .setNamedCredential('DummyNamedCredential')
                .setMethod(XAP_REST_HttpVerb.GET)
                .setPath('/')
                .setQuery('')
                .setBody('')
                .setHeaders(null);

        // Act
        HttpResponse response;
        Test.startTest();
        System.runAs(TEST_USER) {
            response = CLIENT_UNDER_TEST.makeApiCall(testRequest);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(200, response.getStatusCode(), 'Expected the return status code to be 200');
    }

    @IsTest
    static void testStaticMakeApiCallNoHeadersoOrBodyParamsPositive() {
        prepCalloutMock();
        XAP_REST_RestRequest testRequest = new XAP_REST_RestRequest()
                .setNamedCredential('DummyNamedCredential')
                .setMethod(XAP_REST_HttpVerb.GET)
                .setPath('/')
                .setQuery('');

        // Act
        HttpResponse response;
        Test.startTest();
        System.runAs(TEST_USER) {
            response = CLIENT_UNDER_TEST.makeApiCall(testRequest);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(200, response.getStatusCode(), 'Expected the return status code to be 200');
    }

    @IsTest
    static void testStaticMakeApiCallNoHeadersoOrBodyOrQueryParamsPositive() {
        prepCalloutMock();
        XAP_REST_RestRequest testRequest = new XAP_REST_RestRequest()
                .setNamedCredential('DummyNamedCredential')
                .setMethod(XAP_REST_HttpVerb.GET)
                .setPath('/');

        // Act
        HttpResponse response;
        Test.startTest();
        System.runAs(TEST_USER) {
            response = CLIENT_UNDER_TEST.makeApiCall(testRequest);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(200, response.getStatusCode(), 'Expected the return status code to be 200');
    }

    @IsTest
    static void testGetWithPathAndQueryPositive() {
        prepCalloutMock();
        XAP_REST_RestRequest testRequest = new XAP_REST_RestRequest()
                .setNamedCredential('DummyNamedCredential')
                .setPath('/')
                .setQuery('?test');

        // Act
        HttpResponse response;
        Test.startTest();
        System.runAs(TEST_USER) {
            response = CLIENT_UNDER_TEST.get(testRequest);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(200, response.getStatusCode(), 'Expected the return status code to be 200');
    }

    @IsTest
    static void testDelWithPathPositive() {
        prepCalloutMock();
        XAP_REST_RestRequest testRequest = new XAP_REST_RestRequest()
                .setNamedCredential('DummyNamedCredential')
                .setPath('/');

        // Act
        HttpResponse response;
        Test.startTest();
        System.runAs(TEST_USER) {
            response = CLIENT_UNDER_TEST.del(testRequest);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(200, response.getStatusCode(), 'Expected the return status code to be 200');
    }

    @IsTest
    static void testPostWithPathQueryAndBodyPositive() {
        Integer testStatusCode = 201;
        prepCalloutMock(testStatusCode);
        XAP_REST_RestRequest testRequest = new XAP_REST_RestRequest()
                .setNamedCredential('DummyNamedCredential')
                .setPath('/')
                .setQuery('')
                .setBody('{"Id": "003ae3fn12df25k309"}');

        // Act
        HttpResponse response;
        Test.startTest();
        System.runAs(TEST_USER) {
            response = CLIENT_UNDER_TEST.post(testRequest);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(testStatusCode, response.getStatusCode(), 'Expected the return status code to be 200');
    }

    @IsTest
    static void testPutWithPathAndBodyPositive() {
        Integer testStatusCode = 201;
        prepCalloutMock(testStatusCode);
        XAP_REST_RestRequest testRequest = new XAP_REST_RestRequest()
                .setNamedCredential('DummyNamedCredential')
                .setPath('/')
                .setBody('{"Id": "003ae3fn12df25k309"}');

        // Act
        HttpResponse response;
        Test.startTest();
        System.runAs(TEST_USER) {
            response = CLIENT_UNDER_TEST.put(testRequest);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(testStatusCode, response.getStatusCode(), 'Expected the return status code to be 200');
    }

    @IsTest
    static void testPutWithPathQueryAndBodyPositive() {
        Integer testStatusCode = 201;
        prepCalloutMock(testStatusCode);
        XAP_REST_RestRequest testRequest = new XAP_REST_RestRequest()
                .setNamedCredential('DummyNamedCredential')
                .setPath('/')
                .setQuery('')
                .setBody('{"Id": "003ae3fn12df25k309"}');

        // Act
        HttpResponse response;
        Test.startTest();
        System.runAs(TEST_USER) {
            response = CLIENT_UNDER_TEST.put(testRequest);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(testStatusCode, response.getStatusCode(), 'Expected the return status code to be 200');
    }

    @IsTest
    static void testPatchWithPathQueryAndBodyPositive() {
        Integer testStatusCode = 201;
        prepCalloutMock(testStatusCode);
        XAP_REST_RestRequest testRequest = new XAP_REST_RestRequest()
                .setNamedCredential('DummyNamedCredential')
                .setPath('/')
                .setBody('{"Id": "003ae3fn12df25k309"}');

        // Act
        HttpResponse response;
        Test.startTest();
        System.runAs(TEST_USER) {
            response = CLIENT_UNDER_TEST.patch(testRequest);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(testStatusCode, response.getStatusCode(), 'Expected the return status code to be 200');
    }

    private static void prepCalloutMock() {
        prepCalloutMock(200);
    }

    private static void prepCalloutMock(Integer testStatusCode) {
        HttpResponse testResponse = MOCK_CALLOUT.createDefaultResponse();
        testResponse.setStatusCode(testStatusCode);
        testResponse.setBody(XAP_HTTP_HttpSingleCalloutMock.STATUS_OK);
        MOCK_CALLOUT.returnedResponse = testResponse;
        Test.setMock(HttpCalloutMock.class, MOCK_CALLOUT);
    }
}
