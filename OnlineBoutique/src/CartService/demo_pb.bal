import ballerina/grpc;

public type CartServiceBlockingClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function AddItem(AddItemRequest req, grpc:Headers? headers = ()) returns ([Empty, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("hipstershop.CartService/AddItem", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Empty>result, resHeaders];
        
    }

    public remote function GetCart(GetCartRequest req, grpc:Headers? headers = ()) returns ([Cart, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("hipstershop.CartService/GetCart", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Cart>result, resHeaders];
        
    }

    public remote function EmptyCart(EmptyCartRequest req, grpc:Headers? headers = ()) returns ([Empty, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("hipstershop.CartService/EmptyCart", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Empty>result, resHeaders];
        
    }

};

public type CartServiceClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function AddItem(AddItemRequest req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("hipstershop.CartService/AddItem", req, msgListener, headers);
    }

    public remote function GetCart(GetCartRequest req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("hipstershop.CartService/GetCart", req, msgListener, headers);
    }

    public remote function EmptyCart(EmptyCartRequest req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("hipstershop.CartService/EmptyCart", req, msgListener, headers);
    }

};
