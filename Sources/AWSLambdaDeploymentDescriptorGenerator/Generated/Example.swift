
import Foundation

public struct Metadata {}
public struct Conditions {}

// top level = one struct
public struct SAMDeploymentDescriptor: Codable, Sendable {  //Done..✅
  // for each properties in the JSON schema, generate a corresponding
  // swift property with the correct type
  // (optional by default, unless listed under "Required")
  // see line 1050
  let metadata: Metadata?  //Done..✅

  // for patternProperties, the Swift type must be a dictionary [String:XXX]
  // see line 1104
  let resources: [String:Resources]  //Done..✅

  // for properties with an enum, a separate enum must be generated
  // when there is only one value in the neum, in can be used as default
  // see line 1051
  let awsTemplateFormatVersion: AWSTemplateFormatVersion = .v2010_09_09  //Done..✅
  let transform: Transform = .aws_Serverless_2016_10_31  //Done..✅

}

// When a JSON property has a type of "AnyOf",
// we need to generate a Swift enum to represent all cases in the AnyOf
// AnyOf => enum
public enum Resources {  //Done..✅
  case serverlessAPI(ServerlessAPI)
  case serverlessFunction(ServerlessFunction)
  case serverlessSimpleTable(ServerlessSimpleTable)
  case cloudFormationResource(CloudFormationResource)
}

public struct ServlessFunction {
  let deletionPolicy: String
  //...

  let type: ServerlessFunctionType = .serverlessFunction

  public enum ServerlessFunctionType: String {
    case serverlessFunction = "AWS::Serverless::Function"
  }
}

public struct ServerlessAPI {
  let deletionPolicy: String
  //...

  let type: ServerlessAPIType = .serverlessAPI

  public enum ServerlessAPIType: String {
    case serverlessAPI = "AWS::Serverless::Api"
  }
}

// the definitions section of the JSON Schema MUST NOT be generated as a struct,
// instead, each type inside the definition IS a struct (or an enum)
// the rule is "type" : "object" => Swift struct

// for each property under a type "object" in definitions, generate a struct :
// see line 847
public struct ServerlessSimpleTable {
  // each JSON property is a swift property
  let deletionPolicy: String?
  let metadata: MetaData?
  let globals: Globals?

  // the type can be a simple one, or another struct
  // the complex type can be declared inline (see line 877)
  // or can be a reference to definitions (see line 881)
  let properties : ServerlessSimpleTableProperty
}

// this type is defined inline (line 877)
// the type of its properties are definied in the definitions section (see lines 881, 884, 887)
public struct ServerlessSimpleTableProperty {
  let primaryKey : ServelessSimpleTablePrimaryKey?
  let provisionedThroughput : ServelessSimpleTableProvisionedThroughput?
  let sseSpecification : ServelessSimpleTableSSESpecification?
}

// this one is defined under defintions (line 904)
public struct ServerlessSimpleTablePrimaryKey {
  let name: String?
  let type: String
}

/*
// GOALS

 1. DepndsOn
 2. Type enum
 3. coding keys
 4. generate the top level struct JSONSChemaDefinition
*/

//MARK: - Definitions
struct Definitions: Codable { //32..
    let awsServerlessAPI: AWSServerlessAPI
    let awsServerlessAPIS3Location: AwsServerlessS3Location  //Done..✅
    let awsServerlessFunction: AWSServerlessFunction
    let awsServerlessFunctionAlexaSkillEvent: AwsServerlessFunctionEnt
    let awsServerlessFunctionAPIEvent: AWSServerlessFunctionAPIEvent //Done..✅
    let awsServerlessFunctionCloudWatchEventEvent: AWSServerlessFunctionCloudWatchEventEvent
    let awsServerlessFunctionEventBridgeRule: AWSServerlessFunctionEventBridgeRule
    let awsServerlessFunctionLogEvent: AWSServerlessFunctionLogEvent //Done..✅
    let awsServerlessFunctionDeadLetterQueue: AWSServerlessFunctionDeadLetterQueue //Done..✅
    let awsServerlessFunctionCognitoEvent: AWSServerlessFunctionCognitoEvent
    let awsServerlessFunctionDynamoDBEvent: AwsServerlessFunctionEvent //Done..✅
    let awsServerlessFunctionEventSource: AWSServerlessFunctionEventSource //Done..✅
    let awsServerlessFunctionFunctionEnvironment: AwsServerlessFunctionEnt
    let awsServerlessFunctionIAMPolicyDocument: AWSServerlessFunctionIAMPolicyDocument
    let awsServerlessFunctionIoTRuleEvent: AWSServerlessFunctionIoTRuleEvent //Done..✅
    let awsServerlessFunctionKinesisEvent: AwsServerlessFunctionEvent //Done..✅
    let awsServerlessFunctionMSKEvent: AWSServerlessFunctionMSKEvent
    let awsServerlessFunctionMQEvent: AWSServerlessFunctionMQEvent
    let awsServerlessFunctionSQSEvent: AWSServerlessFunctionSQSEvent //Done..✅
    let awsServerlessFunctionS3Event: AWSServerlessFunctionS3Event
    let awsServerlessFunctionS3Location: AwsServerlessS3Location  //Done..✅
    let awsServerlessFunctionS3NotificationFilter: AWSServerlessFunctionS3NotificationFilter
    let awsServerlessFunctionSNSEvent: AWSServerlessFunctionSNSEvent
    let awsServerlessFunctionScheduleEvent: AWSServerlessFunctionScheduleEvent //Done..✅
    let awsServerlessFunctionVpcConfig: AWSServerlessFunctionVpcConfig
    let awsServerlessSimpleTable: AWSServerlessSimpleTable
    let awsServerlessSimpleTablePrimaryKey: AWSServerlessSimpleTablePrimaryKey //Done..✅
    let awsServerlessSimpleTableProvisionedThroughput: AWSServerlessSimpleTableProvisionedThroughput //Done..✅
    let awsServerlessSimpleTableSSESpecification: AWSServerlessSimpleTableSSESpecification //Done..✅
    let cloudFormationResource: CloudFormationResource //Done..✅
    let parameter: Parameter
    let tag: Tag //Done..✅
}
