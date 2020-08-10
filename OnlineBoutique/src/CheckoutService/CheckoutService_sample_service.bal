import ballerina/grpc;
import ballerina/http;
import ballerina/time;
import onlineBoutique/ProductCatalogService;

listener grpc:Listener ep = new (9091);
//Cart service is mocked using mocky.io
http:Client cartServiceEp = new ("https://run.mocky.io/v3/");
ProductCatalogService:ProductCatalogServiceBlockingClient catalogServiceEp = new ("http://localhost:9093");

service CheckoutService on ep {
    resource function PlaceOrder(grpc:Caller caller, PlaceOrderRequest value) {
        //Constant shopping fee
        ProductCatalogService:Money shipping_fee = {units: 100};
        OrderItem[] items = getOrderItems(value.user_id);
        OrderResult result = {
            order_id: generateOrderId(value.user_id),
            shipping_tracking_id: "shipping/0001",
            shipping_cost: shipping_fee,
            shipping_address: value.address,
            items: items
        };
        PlaceOrderResponse order_response = {order: result};
        error? send = caller->send(order_response);
    }
}

function generateOrderId(string userId) returns string {
    time:Time time = time:currentTime();
    int currentTimeMills = time.time;
    string orderId = "order/" + userId + "/" + currentTimeMills.toJsonString();
    return orderId;
}

function calculateCost(string productId) returns ProductCatalogService:Money? {
    ProductCatalogService:ListProductsResponse prodListResponse = {};
    Empty req = {};
    [ProductCatalogService:ListProductsResponse, grpc:Headers]|error response = catalogServiceEp->ListProducts(req);
    if (response is [ProductCatalogService:ListProductsResponse, grpc:Headers]) {
        [prodListResponse, _] = response;
    }
    foreach var product in prodListResponse.products {
        if (product.id == productId) {
            return product.priceUsd;
        }
    }
    return ();
}

function getOrderItems(string userId) returns OrderItem[] {
    OrderItem item;
    OrderItem[] items = [];
    Cart cart = getCart(userId);
    foreach CartItem cartItem in cart.items {
        item = {item: cartItem, cost: calculateCost(cartItem.product_id)};
        items.push(item);
    }
    return items;
}


function getCart(string userId) returns @tainted Cart {
    Cart cart = {};
    // TODO: Enable when CartService is available
    //GetCartRequest cartReq = {user_id: userId};
    //[Cart, grpc:Headers]|grpc:Error serviceResponse = cartServiceEp->GetCart(cartReq);
    //if (serviceResponse is [Cart, grpc:Headers]) {
    //    [cart, _] = serviceResponse;
    //}
    http:Response|error response = cartServiceEp->get("830a6cb1-3404-40fe-9bfb-43d9c2e2a2ec");
    if (response is http:Response) {
        json cartDetails = <json>response.getJsonPayload();
        Cart|error cloneWithTypeResult = cartDetails.cloneWithType(Cart);
        if (cloneWithTypeResult is Cart) {
            cart = cloneWithTypeResult;
        }
    }
    return cart;
}

public type Empty record {|

|};

public type Address record {|
    string street_address = "";
    string city = "";
    string state = "";
    string country = "";
    int zip_code = 0;

|};

public type PlaceOrderRequest record {|
    string user_id = "";
    string user_currency = "";
    Address? address = ();
    string email = "";
    CreditCardInfo? credit_card = ();

|};

public type OrderItem record {|
    CartItem? item = ();
    ProductCatalogService:Money? cost = ();

|};

public type OrderResult record {|
    string order_id = "";
    string shipping_tracking_id = "";
    ProductCatalogService:Money? shipping_cost = ();
    Address? shipping_address = ();
    OrderItem[] items = [];

|};

public type CartItem record {|
    string product_id = "";
    int quantity = 0;

|};

public type PlaceOrderResponse record {|
    OrderResult? order = ();

|};

public type CreditCardInfo record {|
    string credit_card_number = "";
    int credit_card_cvv = 0;
    int credit_card_expiration_year = 0;
    int credit_card_expiration_month = 0;
|};

public type Cart record {|
    string user_id = "";
    CartItem[] items = [];

|};

public type GetCartRequest record {|
    string user_id = "";

|};

public type Product record {|
    string id = "";
    string name = "";
    string description = "";
    string picture = "";
    ProductCatalogService:Money? priceUsd = ();
    string[] categories = [];
|};

const string ROOT_DESCRIPTOR = "0A0A64656D6F2E70726F746F120B6869707374657273686F7022450A08436172744974656D121D0A0A70726F647563745F6964180120012809520970726F647563744964121A0A087175616E7469747918022001280552087175616E7469747922070A05456D707479228F010A074164647265737312250A0E7374726565745F61646472657373180120012809520D7374726565744164647265737312120A046369747918022001280952046369747912140A0573746174651803200128095205737461746512180A07636F756E7472791804200128095207636F756E74727912190A087A69705F636F646518052001280552077A6970436F646522E6010A0E43726564697443617264496E666F122C0A126372656469745F636172645F6E756D6265721801200128095210637265646974436172644E756D62657212260A0F6372656469745F636172645F637676180220012805520D63726564697443617264437676123D0A1B6372656469745F636172645F65787069726174696F6E5F7965617218032001280552186372656469744361726445787069726174696F6E59656172123F0A1C6372656469745F636172645F65787069726174696F6E5F6D6F6E746818042001280552196372656469744361726445787069726174696F6E4D6F6E746822580A054D6F6E657912230A0D63757272656E63795F636F6465180120012809520C63757272656E6379436F646512140A05756E6974731802200128035205756E69747312140A056E616E6F7318032001280552056E616E6F73225E0A094F726465724974656D12290A046974656D18012001280B32152E6869707374657273686F702E436172744974656D52046974656D12260A04636F737418022001280B32122E6869707374657273686F702E4D6F6E65795204636F73742282020A0B4F72646572526573756C7412190A086F726465725F696418012001280952076F72646572496412300A147368697070696E675F747261636B696E675F696418022001280952127368697070696E67547261636B696E67496412370A0D7368697070696E675F636F737418032001280B32122E6869707374657273686F702E4D6F6E6579520C7368697070696E67436F7374123F0A107368697070696E675F6164647265737318042001280B32142E6869707374657273686F702E41646472657373520F7368697070696E6741646472657373122C0A056974656D7318052003280B32162E6869707374657273686F702E4F726465724974656D52056974656D7322D5010A11506C6163654F726465725265717565737412170A07757365725F6964180120012809520675736572496412230A0D757365725F63757272656E6379180220012809520C7573657243757272656E6379122E0A076164647265737318032001280B32142E6869707374657273686F702E4164647265737352076164647265737312140A05656D61696C1805200128095205656D61696C123C0A0B6372656469745F6361726418062001280B321B2E6869707374657273686F702E43726564697443617264496E666F520A6372656469744361726422440A12506C6163654F72646572526573706F6E7365122E0A056F7264657218012001280B32182E6869707374657273686F702E4F72646572526573756C7452056F7264657232620A0F436865636B6F757453657276696365124F0A0A506C6163654F72646572121E2E6869707374657273686F702E506C6163654F72646572526571756573741A1F2E6869707374657273686F702E506C6163654F72646572526573706F6E73652200620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "demo.proto": "0A0A64656D6F2E70726F746F120B6869707374657273686F7022450A08436172744974656D121D0A0A70726F647563745F6964180120012809520970726F647563744964121A0A087175616E7469747918022001280552087175616E7469747922070A05456D707479228F010A074164647265737312250A0E7374726565745F61646472657373180120012809520D7374726565744164647265737312120A046369747918022001280952046369747912140A0573746174651803200128095205737461746512180A07636F756E7472791804200128095207636F756E74727912190A087A69705F636F646518052001280552077A6970436F646522E6010A0E43726564697443617264496E666F122C0A126372656469745F636172645F6E756D6265721801200128095210637265646974436172644E756D62657212260A0F6372656469745F636172645F637676180220012805520D63726564697443617264437676123D0A1B6372656469745F636172645F65787069726174696F6E5F7965617218032001280552186372656469744361726445787069726174696F6E59656172123F0A1C6372656469745F636172645F65787069726174696F6E5F6D6F6E746818042001280552196372656469744361726445787069726174696F6E4D6F6E746822580A054D6F6E657912230A0D63757272656E63795F636F6465180120012809520C63757272656E6379436F646512140A05756E6974731802200128035205756E69747312140A056E616E6F7318032001280552056E616E6F73225E0A094F726465724974656D12290A046974656D18012001280B32152E6869707374657273686F702E436172744974656D52046974656D12260A04636F737418022001280B32122E6869707374657273686F702E4D6F6E65795204636F73742282020A0B4F72646572526573756C7412190A086F726465725F696418012001280952076F72646572496412300A147368697070696E675F747261636B696E675F696418022001280952127368697070696E67547261636B696E67496412370A0D7368697070696E675F636F737418032001280B32122E6869707374657273686F702E4D6F6E6579520C7368697070696E67436F7374123F0A107368697070696E675F6164647265737318042001280B32142E6869707374657273686F702E41646472657373520F7368697070696E6741646472657373122C0A056974656D7318052003280B32162E6869707374657273686F702E4F726465724974656D52056974656D7322D5010A11506C6163654F726465725265717565737412170A07757365725F6964180120012809520675736572496412230A0D757365725F63757272656E6379180220012809520C7573657243757272656E6379122E0A076164647265737318032001280B32142E6869707374657273686F702E4164647265737352076164647265737312140A05656D61696C1805200128095205656D61696C123C0A0B6372656469745F6361726418062001280B321B2E6869707374657273686F702E43726564697443617264496E666F520A6372656469744361726422440A12506C6163654F72646572526573706F6E7365122E0A056F7264657218012001280B32182E6869707374657273686F702E4F72646572526573756C7452056F7264657232620A0F436865636B6F757453657276696365124F0A0A506C6163654F72646572121E2E6869707374657273686F702E506C6163654F72646572526571756573741A1F2E6869707374657273686F702E506C6163654F72646572526573706F6E73652200620670726F746F33"

    };
}
