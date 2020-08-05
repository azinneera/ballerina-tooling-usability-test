import ballerina/http;
import ballerina/test;
import onlineBoutique/ProductCatalogService;

CheckoutServiceBlockingClient checkoutClient = new ("http://localhost:9094");

# Before Suite Function
@test:BeforeSuite
public function setup() {
    cartServiceEp = test:mock(http:Client);
    json mockPayload = {user_id: "user1", items: [{product_id: "66VCHSJNUP", quantity: 1}, {product_id: "L9ECAV7KIM", quantity: 1}]};
    http:Response mockRes = new;
    mockRes.setJsonPayload(mockPayload);
    test:prepare(cartServiceEp).when("get").withArguments("830a6cb1-3404-40fe-9bfb-43d9c2e2a2ec").thenReturn(mockRes);
}

function getOrderRequest() returns PlaceOrderRequest {
    Address shipping_address = {street_address: "", city: "", state: "", country: "", zip_code: 0};
    CreditCardInfo creditCardInfo = {
        credit_card_number: "xxx-xxx-xxxxx",
        credit_card_cvv: 11,
        credit_card_expiration_year: 2023,
        credit_card_expiration_month: 6
    };
    PlaceOrderRequest request = {
        user_id: "user1",
        user_currency: "LKR",
        address: shipping_address,
        email: "test@gmail.com",
        credit_card: creditCardInfo
    };
    return request;
}
// Returns a mock HTTP response to be used for the jokes API invocation
function getMockResponse() returns PlaceOrderResponse {
    //resp
    Address shipping_address = {street_address: "", city: "", state: "", country: "", zip_code: 0};
    ProductCatalogService:Money shipping_fee = {units: 100};
    CartItem cartitem1 = {product_id: "001", quantity: 1};
    CartItem cartitem2 = {product_id: "002", quantity: 2};
    OrderItem item1 = {item: cartitem1, cost: {units: 100}};
    OrderItem item2 = {item: cartitem2, cost: {units: 200}};
    OrderItem[] items = [item1, item2];
    OrderResult result = {
        order_id: "order/user1",
        shipping_tracking_id: "shipping/0001",
        shipping_cost: shipping_fee,
        shipping_address: shipping_address,
        items: items
    };
    PlaceOrderResponse order_response = {order: result};
    return order_response;
}

//@test:Config {
//}
//function testPlaceOrderFunction() {
//    [PlaceOrderResponse, grpc:Headers]|error response = checkoutClient->PlaceOrder(getOrderRequest());
//    PlaceOrderResponse orderResponse = {};
//    if (response is [PlaceOrderResponse, grpc:Headers]) {
//        [orderResponse, _] = response;
//    }
//    test:assertEquals(orderResponse, getMockResponse());
//}

@test:Config {
}
function testGenerateOrderId() {
    string userId = "user1";
    string user_order_string = "order/" + userId + "/";
    string orderId = generateOrderId(userId);
    test:assertTrue(orderId.startsWith(user_order_string));
}

@test:Config {
}
function testGetCart() {
    string userId = "user1";
    Cart expectedCart = {user_id: userId, items: [{product_id: "66VCHSJNUP", quantity: 1}, {product_id: "L9ECAV7KIM", quantity: 1}]};
    Cart actualCart = {};
    http:Response|error response = cartServiceEp->get("830a6cb1-3404-40fe-9bfb-43d9c2e2a2ec");
    if (response is http:Response) {
        json cartDetails = <json>response.getJsonPayload();
        Cart|error cloneWithTypeResult = cartDetails.cloneWithType(Cart);
        if (cloneWithTypeResult is Cart) {
            actualCart = cloneWithTypeResult;
        }
    }
    test:assertEquals(expectedCart, actualCart);
}

