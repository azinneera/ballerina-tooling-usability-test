import ballerina/test;
import ballerina/grpc;
import ballerina/http;
import ballerina/io;
import ballerina/config;

CurrencyServiceBlockingClient blockingEp = new("http://" + config:getAsString("CURRENCY_SERVICE_HOST") 
    + ":" + config:getAsString("CURRENCY_SERVICE_PORT"));

@test:BeforeSuite
public function setup() {
    clientEndpoint = test:mock(http:Client);
}
@test:Config {}
function testConvert() {
    json mockPayload = {"rates":{"GBP":0.75},"base":"USD"};
    http:Response mockRes = new;
    mockRes.setJsonPayload(mockPayload);
    test:prepare(clientEndpoint).when("get").thenReturn(mockRes);

    Money money = {currency_code: "USD"};
    CurrencyConversionRequest convertReq = {'from: money, to_code: "GBP"};
    [Money, grpc:Headers]|error convert = blockingEp->Convert(convertReq);
    if (convert is error) {
        test:assertFail(convert.message());
    } else {
        test:assertEquals(convert[0].units.toString() + "." + convert[0].nanos.toString(), "0.75");
    }
    
}

@test:Config {}
function testGetSupportedCurrencies() {
    json mockPayload = {"rates":{"GBP":0.75},"base":"USD"};
    http:Response mockRes = new;
    mockRes.setJsonPayload(mockPayload);
    test:prepare(clientEndpoint).when("get").thenReturn(mockRes);

    [GetSupportedCurrenciesResponse, grpc:Headers]|error getSupportedCurrencies = blockingEp->GetSupportedCurrencies({});
    if (getSupportedCurrencies is error) {
        test:assertFail(getSupportedCurrencies.message());
    } else {
        io:println(getSupportedCurrencies[0].currency_codes.toString());
        test:assertEquals(getSupportedCurrencies[0].currency_codes, <string[]>["GBP"]);
    }
}

@test:Config {}
function testConvertNegative() {
    error mockError = http:GenericClientError("Bad request");
    test:prepare(clientEndpoint).when("get").thenReturn(mockError);

    [Money, grpc:Headers]|error convert = blockingEp->Convert({});
    test:assertTrue(convert is error);
    
}

@test:Config {}
function testGetSupportedCurrenciesNegative() {
    error mockError = http:GenericClientError("Bad request");
    test:prepare(clientEndpoint).when("get").thenReturn(mockError);

    [GetSupportedCurrenciesResponse, grpc:Headers]|error getSupportedCurrencies = blockingEp->GetSupportedCurrencies({});
    test:assertTrue(getSupportedCurrencies is error);
    
}
