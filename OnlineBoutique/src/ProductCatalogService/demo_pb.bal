import ballerina/grpc;

public type ProductCatalogServiceBlockingClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function ListProducts(Empty req, grpc:Headers? headers = ()) returns ([ListProductsResponse, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("hipstershop.ProductCatalogService/ListProducts", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<ListProductsResponse>result, resHeaders];
        
    }

    public remote function GetProduct(GetProductRequest req, grpc:Headers? headers = ()) returns ([Product, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("hipstershop.ProductCatalogService/GetProduct", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Product>result, resHeaders];
        
    }

    public remote function SearchProducts(SearchProductsRequest req, grpc:Headers? headers = ()) returns ([SearchProductsResponse, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("hipstershop.ProductCatalogService/SearchProducts", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<SearchProductsResponse>result, resHeaders];
        
    }

};

public type ProductCatalogServiceClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function ListProducts(Empty req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("hipstershop.ProductCatalogService/ListProducts", req, msgListener, headers);
    }

    public remote function GetProduct(GetProductRequest req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("hipstershop.ProductCatalogService/GetProduct", req, msgListener, headers);
    }

    public remote function SearchProducts(SearchProductsRequest req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("hipstershop.ProductCatalogService/SearchProducts", req, msgListener, headers);
    }

};

