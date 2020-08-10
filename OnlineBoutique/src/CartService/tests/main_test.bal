import ballerina/grpc;
import ballerina/test;

CartServiceBlockingClient blockingEp = new ("http://localhost:9090");

@test:Config {}
function testAddItem() {
    AddItemRequest addItem = {
        user_id: "FA012345",
        item: {
            product_id: "PA54321",
            quantity: 2
        }
    };

    [Empty, grpc:Headers]|error addItemRes = blockingEp->AddItem(addItem);

    if (addItemRes is error) {
        test:assertFail(addItemRes.message());
    }
}
