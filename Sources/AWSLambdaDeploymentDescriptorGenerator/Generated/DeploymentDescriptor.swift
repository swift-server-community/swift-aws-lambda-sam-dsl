public struct SAMDeploymentDescriptor: Codable, Sendable {
    let mappings: Mappings
    let conditions: Conditions
    let description: String
    let transform: Transform = .aws_Serverless_2016_10_31
    let awsTemplateFormatVersion: AWSTemplateFormatVersion = .v2010_09_09
    let outputs: Outputs
    let parameters: Parameters
    let resources: [String: Resources]

    public enum Resources: String, Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    private enum CodingKeys: String, CodingKey {
        case mappings = "Mappings"
        case conditions = "Conditions"
        case description = "Description"
        case transform = "Transform"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case outputs = "Outputs"
        case parameters = "Parameters"
        case resources = "Resources"
    }
}
public struct ServerlessFunctionSNSEvent: Codable, Sendable {
    let region: String
    let topic: String
    let filterPolicy: FilterPolicy
    let filterPolicyScope: String
}
public struct CloudFormationResource: Codable, Sendable {
    let type: String
}
public struct ServerlessSimpleTablePrimaryKey: Codable, Sendable {
    let type: String
    let name: String
}
public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: Variables
}
public struct ServerlessFunctionEventSource: Codable, Sendable {
    let type: String
}
public struct ServerlessFunctionS3Event: Codable, Sendable {
    let filter: not supported yet ⚠️
}
public struct ServerlessFunctionLogEvent: Codable, Sendable {
    let logGroupName: String
    let filterPattern: String
}
public struct ServerlessApiS3Location: Codable, Sendable {
    let bucket: String
    let version: Double
    let key: String
}
public struct Parameter: Codable, Sendable {
    let maxLength: String
    let constraintDescription: String
    let minLength: String
    let type: Type
    let minValue: String
    let allowedPattern: String
    let default: String
    let description: String
    let noEcho: not supported yet ⚠️
    let maxValue: String
    let allowedValues: [Any]
}
public struct Tag: Codable, Sendable {
    let key: String
}
public struct ServerlessFunctionApiEvent: Codable, Sendable {
    let path: String
    let method: String
}
public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
    let inputPath: String
    let pattern: Pattern
    let deadLetterConfig: DeadLetterConfig
    let input: String
    let ruleName: String
    let retryPolicy: RetryPolicy
    let state: String
}
public struct ServerlessApi: Codable, Sendable {
    let metadata: Metadata
    let deletionPolicy: String
    let condition: String
    let type: Type
    let properties: Properties
    let updateReplacePolicy: String
}
public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let schedule: String
    let name: String
    let enabled: Bool
    let description: String
    let input: String
}
public struct ServerlessFunctionS3Location: Codable, Sendable {
    let bucket: String
    let version: Double
    let key: String
}
public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {
    let statement: [Statement]
}
public struct ServerlessFunctionMSKEvent: Codable, Sendable {
    let stream: String
    let topics: [Any]
    let startingPosition: String
}
public struct ServerlessFunctionDeadLetterQueue: Codable, Sendable {
    let type: String
    let targetArn: String
}
public struct ServerlessFunction: Codable, Sendable {
    let updateReplacePolicy: String
    let metadata: Metadata
    let type: Type
    let deletionPolicy: String
    let condition: String
}
public struct ServerlessSimpleTableProvisionedThroughput: Codable, Sendable {
    let readCapacityUnits: Double
    let writeCapacityUnits: Double
}
public struct ServerlessFunctionMQEvent: Codable, Sendable {
    let queues: [Any]
    let sourceAccessConfigurations: [Any]
    let broker: String
}
public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let inputPath: String
    let input: String
    let eventBusName: String
    let pattern: Pattern
}
public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let startingPosition: String
    let batchSize: Double
    let stream: String
    let enabled: Bool
}
public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: Variables
}
public struct ServerlessFunctionS3NotificationFilter: Codable, Sendable {
}
public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool
}
public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let startingPosition: String
    let enabled: Bool
    let stream: String
    let batchSize: Double
}
public struct ServerlessFunctionCognitoEvent: Codable, Sendable {
}
public struct ServerlessFunctionVpcConfig: Codable, Sendable {
    let subnetIds: [String]
    let securityGroupIds: [String]
    let subnetIdsUsingRef: [SubnetIdsUsingRef]
}
public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    let enabled: Bool
    let batchSize: Double
}
public struct ServerlessSimpleTable: Codable, Sendable {
    let type: Type
    let condition: String
    let properties: Properties
    let deletionPolicy: String
    let metadata: Metadata
    let updateReplacePolicy: String
}
public struct ServerlessFunctionIoTRuleEvent: Codable, Sendable {
    let sql: String
    let awsIotSqlVersion: String
}