import ballerina/test;
import ballerina/grpc;
import ballerina/http;

CurrencyServiceBlockingClient blockingEp = new("http://localhost:9090");

@test:BeforeSuite
public function setup() {
    json mockPayload = {"rates":{"GBP":0.75},"base":"USD"};
    http:Response mockRes = new;
    mockRes.setJsonPayload(mockPayload);
    clientEndpoint = test:mock(http:Client);
    test:prepare(clientEndpoint).when("get").thenReturn(mockRes);
}
@test:Config {}
function testConvert() {
    Money money = {currency_code: "USD"};
    CurrencyConversionRequest convertReq = {'from: money, to_code: "GBP"};
    [Money, grpc:Headers]|error convert = blockingEp->Convert(convertReq);
    if (convert is error) {
        test:assertFail(convert.message());
    } else {
        test:assertEquals(convert[0].units.toString() + "." + convert[0].nanos.toString(), "0.75");
    }
    
}
