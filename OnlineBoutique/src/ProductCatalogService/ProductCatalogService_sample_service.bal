import ballerina/grpc;
import ballerina/io;
import ballerina/ 'log;

listener grpc:Listener ep = new (9090);

service ProductCatalogService on ep {

    resource function ListProducts(grpc:Caller caller, Empty value) {
        string filePath = "src/ProductCatalogService/resources/products.json";
        ListProductsResponse response = {};
        json|error productResp = read(filePath);
        if (productResp is json) {
            json[]|error productsArr = <json[]>(productResp.products);
            if (productsArr is json[]) {
                foreach json product in productsArr {
                    Product|error prod = product.cloneWithType(Product);
                    if (prod is Product) {
                        response.products.push(prod);
                    }
                }
            }
        }
        error? send = caller->send(response);
    }

    resource function GetProduct(grpc:Caller caller, GetProductRequest value) {
    // Implementation goes here.

    // You should return a Product
    }
    resource function SearchProducts(grpc:Caller caller, SearchProductsRequest value) {
    // Implementation goes here.

    // You should return a SearchProductsResponse
    }
}

public type Money record {|
    string currencyCode = "";
    int units = 0;
    int nanos = 0;

|};

public type Empty record {|

|};

public type SearchProductsResponse record {|
    Product[] results = [];

|};

public type SearchProductsRequest record {|
    string query = "";

|};

public type GetProductRequest record {|
    string id = "";

|};

public type ListProductsResponse record {|
    Product[] products = [];

|};

public type Product record {|
    string id = "";
    string name = "";
    string description = "";
    string picture = "";
    Money? priceUsd = ();
    string[] categories = [];
|};


const string ROOT_DESCRIPTOR = "0A0A64656D6F2E70726F746F120B6869707374657273686F7022070A05456D70747922BA010A0750726F64756374120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12180A0770696374757265180420012809520770696374757265122F0A0970726963655F75736418052001280B32122E6869707374657273686F702E4D6F6E657952087072696365557364121E0A0A63617465676F72696573180620032809520A63617465676F7269657322480A144C69737450726F6475637473526573706F6E736512300A0870726F647563747318012003280B32142E6869707374657273686F702E50726F64756374520870726F647563747322230A1147657450726F6475637452657175657374120E0A02696418012001280952026964222D0A1553656172636850726F64756374735265717565737412140A0571756572791801200128095205717565727922480A1653656172636850726F6475637473526573706F6E7365122E0A07726573756C747318012003280B32142E6869707374657273686F702E50726F647563745207726573756C747322580A054D6F6E657912230A0D63757272656E63795F636F6465180120012809520C63757272656E6379436F646512140A05756E6974731802200128035205756E69747312140A056E616E6F7318032001280552056E616E6F733283020A1550726F64756374436174616C6F675365727669636512470A0C4C69737450726F647563747312122E6869707374657273686F702E456D7074791A212E6869707374657273686F702E4C69737450726F6475637473526573706F6E7365220012440A0A47657450726F64756374121E2E6869707374657273686F702E47657450726F64756374526571756573741A142E6869707374657273686F702E50726F647563742200125B0A0E53656172636850726F647563747312222E6869707374657273686F702E53656172636850726F6475637473526571756573741A232E6869707374657273686F702E53656172636850726F6475637473526573706F6E73652200620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "demo.proto": "0A0A64656D6F2E70726F746F120B6869707374657273686F7022070A05456D70747922BA010A0750726F64756374120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12180A0770696374757265180420012809520770696374757265122F0A0970726963655F75736418052001280B32122E6869707374657273686F702E4D6F6E657952087072696365557364121E0A0A63617465676F72696573180620032809520A63617465676F7269657322480A144C69737450726F6475637473526573706F6E736512300A0870726F647563747318012003280B32142E6869707374657273686F702E50726F64756374520870726F647563747322230A1147657450726F6475637452657175657374120E0A02696418012001280952026964222D0A1553656172636850726F64756374735265717565737412140A0571756572791801200128095205717565727922480A1653656172636850726F6475637473526573706F6E7365122E0A07726573756C747318012003280B32142E6869707374657273686F702E50726F647563745207726573756C747322580A054D6F6E657912230A0D63757272656E63795F636F6465180120012809520C63757272656E6379436F646512140A05756E6974731802200128035205756E69747312140A056E616E6F7318032001280552056E616E6F733283020A1550726F64756374436174616C6F675365727669636512470A0C4C69737450726F647563747312122E6869707374657273686F702E456D7074791A212E6869707374657273686F702E4C69737450726F6475637473526573706F6E7365220012440A0A47657450726F64756374121E2E6869707374657273686F702E47657450726F64756374526571756573741A142E6869707374657273686F702E50726F647563742200125B0A0E53656172636850726F647563747312222E6869707374657273686F702E53656172636850726F6475637473526571756573741A232E6869707374657273686F702E53656172636850726F6475637473526573706F6E73652200620670726F746F33"

    };
}

function closeRc(io:ReadableCharacterChannel rc) {
    var result = rc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
            err = result);
    }
}

function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
            err = result);
    }
}

function write(json content, string path) returns @tainted error? {

    io:WritableByteChannel wbc = check io:openWritableFile(path);

    io:WritableCharacterChannel wch = new (wbc, "UTF8");
    var result = wch.writeJson(content);
    closeWc(wch);
    return result;
}

function read(string path) returns @tainted json|error {

    io:ReadableByteChannel rbc = check io:openReadableFile(path);

    io:ReadableCharacterChannel rch = new (rbc, "UTF8");
    var result = rch.readJson();
    closeRc(rch);
    return result;
}
