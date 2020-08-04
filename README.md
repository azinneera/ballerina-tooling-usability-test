# Ballerina Tooling Usability Test

This contains the test plan for conducting the usability test for Ballerina Tooling. The goal of this usability test
 is to identify potential bugs and improvements in Developer Tools in order to improve the end-user satisfaction.
  

## Usability Test Tasks

Assessing the usability of Ballerina Tooling will be covered using several tasks. Each task will assess one or more
 areas of Ballerina Tooling

### 1. Online Boutique Application

This application is used to assess the usability of the Ballerina test framework, specifically on the Mocking feature.

#### Overview of the sample

This is a sample cloud-native application inspired by the [Online Boutique (HipsterShop) sample by Google
](https://github.com/GoogleCloudPlatform/microservices-demo). Google uses this application to demonstrate use of technologies like Kubernetes/GKE, Istio, Stackdriver, gRPC and OpenCensus.
You will be developing a simpler version of this sample in order to test the mocking capabilities of the Ballerina Test Framework.
 
This demo application consists of 5 microservices which communicates over gRPC. The application is a web-based e
-commerce app where users can browse items, add them to the cart, and purchase them.
 
![Service Architecture](/OnlineBoutique/images/architecture.png)

#### Objectives

To determine inconsistencies and usability problems of the test framework. Sources of errors include the following:
 
 * Mocking API - Bugs or improvements related to the feature implementation
 * Code coverage - Bugs or improvements related to the feature implementation and the HTML report
 * Documentation issues - Issues or improvements related to the documentation

#### Pre-requisites: 
* Ballerina Swan Lake Preview2

    Visit https://ballerina.io/downloads/ to install the Ballerina Swan Lake Preview2 version as well as the VSCode or
  IntelliJ IDEA plugins.
  
#### Implementation instructions 
  
Your task is to implement the above services using Ballerina and to write unit tests for them. For this, clone this
 repository, implement the assigned service with unit tests and push the code.

##### 1. Product Catalog Service

**Description:** Provides the list of products from a JSON file and ability to search products and get individual
 products.
     
**Resource Implementation:**

| Resource (API)                                | Request inputs (Query parameters) | Response                                    |
|-----------------------------------------------|-----------------------------------|---------------------------------------------|
| Get all products                              | N/A                               | JSON array of products/FileRead error                      |
| Get product by ID                             | Product ID string                 | Product JSON object/Product Not Found error |
| Search a product by name/category/description | Search string                     | Product JSON object/Product Not Found error |

##### 2. Email Service

**Description:** Sends the user an order confirmation email
     
**Resource Implementation:**

| Resource (API)  | Request inputs (Query parameters) | Response                   |
|-----------------|-----------------------------------|----------------------------|
| Send email      | Email address string              | Success/EmailNotSent error |

##### 3. Payment Service

**Description:** Charges the given credit card info with the given amount and returns a transaction ID.
     
**Resource Implementation:**

| Resource (API)  | Request inputs (Query parameters) | Response                               |
|-----------------|-----------------------------------|----------------------------------------|
| Process payment | - Credit card number<br>- Amount  | TransactionID/Transaction failed error |

##### 4. Cart Service

**Description:** Stores the items in the user's shopping cart in Redis and retrieves it.
     
**Resource Implementation:**

| Resource (API)         | Request inputs (Query parameters) | Response                                     |
|------------------------|-----------------------------------|----------------------------------------------|
| Add product to cart    | - Product ID<br>- Quantity        | Success/Update failed error                  |
| Clear cart             | N/A                               | Success/Update failed error                  |
| Retrieve shopping cart | N/A                               | Shopping cart JSON array/Communication error |

##### 5. Checkout Service

**Description:** Retrieves user cart, prepares order and orchestrates the payment, shipping and the email notification.
     
**Resource Implementation:**

| Resource (API)  | Request inputs (Query parameters)                      | Response                          |
|-----------------|--------------------------------------------------------|-----------------------------------|
| Checkout cart   | - Credit card number<br>- Amount<br>- Shipping Address | Order ID/Transaction failed error |

##### 6. Currency Service

**Description:** Converts one money amount to another currency. Uses real values fetched from the https://api.exchangeratesapi.io API

**Resource Implementation:**

| Resource (API)  | Request inputs (Query parameters)   | Response       |
|-----------------|-------------------------------------|----------------|
| Convert         | - to <br> -from                     | Converted rate |

 
#### References

You may use the following documentations and more sources as reference for developing the services and writing unit
 tests.
 * https://ballerina.io/swan-lake/learn/by-example/
 * https://ballerina.io/swan-lake/learn/deployment/
 * https://ballerina.io/swan-lake/learn/testing-ballerina-code/ 
 * https://dzone.com/articles/grpc-basics-why-when-and-how