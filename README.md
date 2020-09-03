# scratch
An Example project to demonstrate the use of SAM,
API Gateway, Lambda, S3 and DynamoDB

Scratch implements a simple API intended to demonstrate
the use of various AWS features to produce a comments
capability for a static web page. (Eventually you will
be able to see it in action by visiting
https://meadhbh-hamrick.github.io/ or
https://meadhbh.hamrick.rocks/ )

The basic information flow is simple:

   
      +-------------+      +-------------+      +-------------+      +-------------+
      |     Web     | ---> |             | ---> |             | ---> |             |
      |    Client   |      | API Gateway |      |  AWS Lambda |      |   DynamoDB  |
      |  (Browser)  | <--- |             | <--- |             | <--- |             |
      +-------------+      +-------------+      +-------------+      +-------------+
                                  |                    |                    |
                                  |                    v                    |
                                  |             +-------------+             |
                                  |             |             |             |
                                  +-----------> | Log Manager | <-----------+
                                                |             |
                                                +-------------+
      
      Diagram I : Basic Information Flow

1. The client (web browser) makes a request to the back
   end.
1. The request is received by the API Gateway and
   forwarded to an AWS Lambda Function.
1. The AWS Lambda Function receives the request, parses
   it and figures out what to do with it, using DynamoDB
   as a persistence tier.
1. DynamoDB receives queries from Lambda Functions,
   updating long term storage as required.

All AWS services generate log messages, which are
collected and displayed via the AWS console.
