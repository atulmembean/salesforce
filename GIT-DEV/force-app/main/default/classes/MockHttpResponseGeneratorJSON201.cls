@isTest
global class MockHttpResponseGeneratorJSON201 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        //res.setBody('{"animal": {"id":"1", "name":"Tiger"}, {"href":"https://www.sandbox.paypal.com/invoice/p/#P2WLJXKVMLJXR8HZ"}}');
        res.setBody('{"href":"https://www.sandbox.paypal.com/invoice/p/#P2WLJXKVMLJXR8HZ"}');
        res.setStatusCode(201);
        return res;
    }
}