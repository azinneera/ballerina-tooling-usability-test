import ballerina/grpc;

public type CheckoutServiceBlockingClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new (url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function PlaceOrder(PlaceOrderRequest req, grpc:Headers? headers = ()) returns ([PlaceOrderResponse, grpc:Headers]|grpc:Error) {

        var payload = check self.grpcClient->blockingExecute("hipstershop.CheckoutService/PlaceOrder", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;

        return [<PlaceOrderResponse>result, resHeaders];

    }

};

public type CheckoutServiceClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new (url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function PlaceOrder(PlaceOrderRequest req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        return self.grpcClient->nonBlockingExecute("hipstershop.CheckoutService/PlaceOrder", req, msgListener, headers);
    }

};


