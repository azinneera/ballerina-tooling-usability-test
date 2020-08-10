import ballerina/config;
import ballerina/grpc;
import ballerina/io;
import ballerina/mysql;
import ballerina/sql;
import ballerina/log;

listener grpc:Listener ep = new (9090);

// create mysql connection.
mysql:Client mysqlClient = check new (
    "localhost",
    config:getAsString("DATABASE_USERNAME", "root"),
    config:getAsString("DATABASE_PASSWORD", "root"),
    config:getAsString("DATABASE_NAME", "testdb"),
    3306
);

service CartService on ep {

    resource function AddItem(grpc:Caller caller, AddItemRequest value) returns error? {
        // Implementation goes here.
        string userId = value.user_id;
        CartItem cartItem = <CartItem>value.item;
        boolean success = 
            insertData(mysqlClient, <@untainted>userId, <@untainted>cartItem.product_id, <@untainted>cartItem.quantity);

        if (success) {
            Empty empty = {};
            error? send = caller->send(empty);
            error? complete = caller->complete();
            if (send is error || complete is error) {
                log:printError("Add item request failed.");
            } else {
                log:printInfo("Add item request successful.");
            }
        } else {
            error? sendError = caller->sendError(grpc:UNKNOWN, "Add item request failed.");
            log:printError("Add item request failed.");
        }
    }
    resource function GetCart(grpc:Caller caller, GetCartRequest value) {
    // Implementation goes here.

    // You should return a Cart
    }
    resource function EmptyCart(grpc:Caller caller, EmptyCartRequest value) {
    // Implementation goes here.

    // You should return a Empty
    }
}

public type EmptyCartRequest record {|
    string user_id = "";

|};

public type Empty record {|

|};

public type Error record {|

|};

public type GetCartRequest record {|
    string user_id = "";

|};

public type AddItemRequest record {|
    string user_id = "";
    CartItem? item = ();

|};

public type CartItem record {|
    string product_id = "";
    int quantity = 0;

|};

public type Cart record {|
    string user_id = "";
    CartItem[] items = [];

|};



const string ROOT_DESCRIPTOR = "0A0A64656D6F2E70726F746F120B6869707374657273686F7022450A08436172744974656D121D0A0A70726F647563745F6964180120012809520970726F647563744964121A0A087175616E7469747918022001280552087175616E7469747922540A0E4164644974656D5265717565737412170A07757365725F6964180120012809520675736572496412290A046974656D18022001280B32152E6869707374657273686F702E436172744974656D52046974656D222B0A10456D707479436172745265717565737412170A07757365725F6964180120012809520675736572496422290A0E476574436172745265717565737412170A07757365725F69641801200128095206757365724964224C0A044361727412170A07757365725F69641801200128095206757365724964122B0A056974656D7318022003280B32152E6869707374657273686F702E436172744974656D52056974656D7322070A05456D70747932CA010A0B4361727453657276696365123C0A074164644974656D121B2E6869707374657273686F702E4164644974656D526571756573741A122E6869707374657273686F702E456D7074792200123B0A0747657443617274121B2E6869707374657273686F702E47657443617274526571756573741A112E6869707374657273686F702E43617274220012400A09456D70747943617274121D2E6869707374657273686F702E456D70747943617274526571756573741A122E6869707374657273686F702E456D7074792200620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "demo.proto": "0A0A64656D6F2E70726F746F120B6869707374657273686F7022450A08436172744974656D121D0A0A70726F647563745F6964180120012809520970726F647563744964121A0A087175616E7469747918022001280552087175616E7469747922540A0E4164644974656D5265717565737412170A07757365725F6964180120012809520675736572496412290A046974656D18022001280B32152E6869707374657273686F702E436172744974656D52046974656D222B0A10456D707479436172745265717565737412170A07757365725F6964180120012809520675736572496422290A0E476574436172745265717565737412170A07757365725F69641801200128095206757365724964224C0A044361727412170A07757365725F69641801200128095206757365724964122B0A056974656D7318022003280B32152E6869707374657273686F702E436172744974656D52056974656D7322070A05456D70747932CA010A0B4361727453657276696365123C0A074164644974656D121B2E6869707374657273686F702E4164644974656D526571756573741A122E6869707374657273686F702E456D7074792200123B0A0747657443617274121B2E6869707374657273686F702E47657443617274526571756573741A112E6869707374657273686F702E43617274220012400A09456D70747943617274121D2E6869707374657273686F702E456D70747943617274526571756573741A122E6869707374657273686F702E456D7074792200620670726F746F33"

    };
}

public function insertData(mysql:Client mysqlClient, string userId, string productId, int qty) returns boolean { 
    sql:ParameterizedQuery insertQuery = 
        `INSERT INTO cart (userId, productId, qty) VALUES (${userId}, ${productId}, ${qty})`;
    sql:ExecutionResult|sql:Error result = mysqlClient->execute(insertQuery);

    if (result is sql:ExecutionResult) {
        io:println("Insert success, generated Id: ", result.lastInsertId);
        return true;
    } else {
        io:println("Error occurred: ", result);
        return false;
    }
}
