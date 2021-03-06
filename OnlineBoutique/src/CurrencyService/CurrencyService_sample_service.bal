import ballerina/grpc;
import ballerina/http;
import ballerina/math;
import ballerina/log;
import ballerina/config;

listener grpc:Listener ep = new (config:getAsInt("CURRENCY_SERVICE_PORT"));

http:Client clientEndpoint = new ("https://api.exchangeratesapi.io");

service CurrencyService on ep {

    resource function GetSupportedCurrencies(grpc:Caller caller, Empty value) returns error? {
        http:Response|error response = clientEndpoint->get("/latest");
        string[] currency_codes = [];
        if (response is http:Response) {
            json conversions = <json>response.getJsonPayload();
            map<json> rates = <map<json>>conversions.rates;
            foreach var [k, v] in rates.entries() {
                currency_codes.push(k.toJsonString());
            }
            GetSupportedCurrenciesResponse supportedCurrenciesRes = {currency_codes: currency_codes};
            check caller->send(supportedCurrenciesRes);
            check caller->complete();
            log:printInfo("Supported currencies request successful.");
        } else {
            error? sendError = caller->sendError(grpc:UNKNOWN, response.message());
        }
        // You should return a GetSupportedCurrenciesResponse
    }

    resource function Convert(grpc:Caller caller, CurrencyConversionRequest value) returns error? {
        Money baseMoney = <Money>value.'from;
        string context = "/latest?base=" + baseMoney.currency_code;
        
        http:Response|error response = clientEndpoint->get(<@untainted> context); 
        if (response is http:Response) {
            json conversions = <json>response.getJsonPayload();
            json rates = <json>conversions.rates;
            float rate = <float>rates.GBP;
            int units = <int>math:floor(rate);
            float nanosAbs = (rate - math:floor(rate))*100;
            int nanos = <int>nanosAbs;
            Money money = {units: units, nanos: nanos};
           
            check caller->send(money);
            check caller->complete();
            log:printInfo("Conversion request successful.");
        } else {
            error? sendError = caller->sendError(grpc:UNKNOWN, response.message());
        }
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

