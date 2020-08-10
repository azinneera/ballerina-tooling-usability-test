import ballerina/grpc;
import ballerina/test;

ProductCatalogServiceBlockingClient clientEndpoint = new ("http://postman-echo.com");

json mockProduct = {
    "id": "OLJCESPC7Z",
    "name": "Vintage Typewriter",
    "description": "This typewriter looks good in your living room.",
    "picture": "/static/img/products/typewriter.jpg",
    "priceUsd": {
        "currencyCode": "USD",
        "units": 67,
        "nanos": 990000000
    },
    "categories": ["vintage"]
};

# Before Suite Function
@test:BeforeSuite
function beforeSuiteFunc() {
    clientEndpoint = test:mock(ProductCatalogServiceBlockingClient);
    Product|error cloneWithTypeResult = mockProduct.cloneWithType(Product);
    ListProductsResponse listProductsResponse = {};
    if (cloneWithTypeResult is Product) {
        listProductsResponse.products.push(cloneWithTypeResult);
    }
    Empty req = {};
    [ListProductsResponse, grpc:Headers] mockResponse = [listProductsResponse, new];
    test:prepare(clientEndpoint).when("ListProducts").withArguments(req).thenReturn(mockResponse);
}

# Before test function
function beforeFunc() {
}

# Test function

@test:Config {
    before: "beforeFunc",
    after: "afterFunc"
}
function testFunction() {
    Empty req = {};
    [ListProductsResponse, grpc:Headers]|error response = clientEndpoint->ListProducts(req);
    if (response is [ListProductsResponse, grpc:Headers]) {
        ListProductsResponse listProductsResponse = {};
        [listProductsResponse, _] = response;
        Product|error cloneWithTypeResult = mockProduct.cloneWithType(Product);
        if (cloneWithTypeResult is Product) {
            test:assertEquals(listProductsResponse.products[0], cloneWithTypeResult);
        } else {
            test:assertFail("Error occurred when trying to map json->Product");
        }
    } else {
        test:assertFail("Respose is invalid");
    }
}

# After test function
function afterFunc() {
}

# After Suite Function
@test:AfterSuite
function afterSuiteFunc() {
}
