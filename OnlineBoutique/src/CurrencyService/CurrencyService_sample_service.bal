import ballerina/grpc;

listener grpc:Listener ep = new (9090);

service CurrencyService on ep {

    resource function GetSupportedCurrencies(grpc:Caller caller, Empty value) {
        // Implementation goes here.

        // You should return a GetSupportedCurrenciesResponse
    }
    resource function Convert(grpc:Caller caller, CurrencyConversionRequest value) returns error? {
        // TODO: use https://api.exchangeratesapi.io/ for currency conversion 
        Money money = {units: 100};
        
        check caller->send(money);
        check caller->complete();
    }
}

public type Money record {|
    string currency_code = "";
    int units = 0;
    int nanos = 0;
    
|};

public type Empty record {|
    
|};

public type CurrencyConversionRequest record {|
    Money? 'from = ();
    string to_code = "";
    
|};

public type GetSupportedCurrenciesResponse record {|
    string[] currency_codes = [];
    
|};



const string ROOT_DESCRIPTOR = "0A0A64656D6F2E70726F746F120B6869707374657273686F7022070A05456D70747922580A054D6F6E657912230A0D63757272656E63795F636F6465180120012809520C63757272656E6379436F646512140A05756E6974731802200128035205756E69747312140A056E616E6F7318032001280552056E616E6F7322470A1E476574537570706F7274656443757272656E63696573526573706F6E736512250A0E63757272656E63795F636F646573180120032809520D63757272656E6379436F646573225C0A1943757272656E6379436F6E76657273696F6E5265717565737412260A0466726F6D18012001280B32122E6869707374657273686F702E4D6F6E6579520466726F6D12170A07746F5F636F64651802200128095206746F436F646532B7010A0F43757272656E637953657276696365125B0A16476574537570706F7274656443757272656E6369657312122E6869707374657273686F702E456D7074791A2B2E6869707374657273686F702E476574537570706F7274656443757272656E63696573526573706F6E7365220012470A07436F6E7665727412262E6869707374657273686F702E43757272656E6379436F6E76657273696F6E526571756573741A122E6869707374657273686F702E4D6F6E65792200620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "demo.proto":"0A0A64656D6F2E70726F746F120B6869707374657273686F7022070A05456D70747922580A054D6F6E657912230A0D63757272656E63795F636F6465180120012809520C63757272656E6379436F646512140A05756E6974731802200128035205756E69747312140A056E616E6F7318032001280552056E616E6F7322470A1E476574537570706F7274656443757272656E63696573526573706F6E736512250A0E63757272656E63795F636F646573180120032809520D63757272656E6379436F646573225C0A1943757272656E6379436F6E76657273696F6E5265717565737412260A0466726F6D18012001280B32122E6869707374657273686F702E4D6F6E6579520466726F6D12170A07746F5F636F64651802200128095206746F436F646532B7010A0F43757272656E637953657276696365125B0A16476574537570706F7274656443757272656E6369657312122E6869707374657273686F702E456D7074791A2B2E6869707374657273686F702E476574537570706F7274656443757272656E63696573526573706F6E7365220012470A07436F6E7665727412262E6869707374657273686F702E43757272656E6379436F6E76657273696F6E526571756573741A122E6869707374657273686F702E4D6F6E65792200620670726F746F33"
        
    };
}

