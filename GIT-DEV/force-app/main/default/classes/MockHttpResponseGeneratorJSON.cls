@isTest
global class MockHttpResponseGeneratorJSON implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"animal": {"id":1, "name":"Tiger"}}');
        res.setStatusCode(200);
        return res;
    }
}