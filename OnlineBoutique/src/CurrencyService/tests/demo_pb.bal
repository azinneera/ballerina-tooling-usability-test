import ballerina/grpc;

public type CurrencyServiceBlockingClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function GetSupportedCurrencies(Empty req, grpc:Headers? headers = ()) returns ([GetSupportedCurrenciesResponse, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("hipstershop.CurrencyService/GetSupportedCurrencies", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<GetSupportedCurrenciesResponse>result, resHeaders];
        
    }

    public remote function Convert(CurrencyConversionRequest req, grpc:Headers? headers = ()) returns ([Money, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("hipstershop.CurrencyService/Convert", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Money>result, resHeaders];
        
    }

};

public type CurrencyServiceClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function GetSupportedCurrencies(Empty req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("hipstershop.CurrencyService/GetSupportedCurrencies", req, msgListener, headers);
    }

    public remote function Convert(CurrencyConversionRequest req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("hipstershop.CurrencyService/Convert", req, msgListener, headers);
    }

};
