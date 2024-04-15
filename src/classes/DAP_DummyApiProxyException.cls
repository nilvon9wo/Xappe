public with sharing class DAP_DummyApiProxyException extends Exception {
    public static DAP_DummyApiProxyException CreateFor(HttpResponse response, DAP_ErrorInputDto errorDto) {
        String message = 'Request to Dummy API was ' + response.getStatusCode()
                + ' ' + response.getStatus()
                + ' because ' + errorDto.error;
        return new DAP_DummyApiProxyException(message);
    }
}