// ===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftAWSLambdaRuntime open source project
//
// Copyright (c) 2023 Apple Inc. and the SwiftAWSLambdaRuntime project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftAWSLambdaRuntime project authors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

public struct SAMDeploymentDescriptor: Codable, Sendable {

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09

    public struct Conditions: Codable, Sendable {
    }
    let conditions: [String: Conditions]?

    public struct Properties: Codable, Sendable {
    }
    let properties: Properties?

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }
    let transform: Transform? = .aws_Serverless_2016_10_31

    public struct Globals: Codable, Sendable {
    }
    let globals: Globals?

    public struct Outputs: Codable, Sendable {
    }
    let outputs: [String: Outputs]?
    let parameters: [String: Parameter]?
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }

    public struct Mappings: Codable, Sendable {
    }
    let mappings: [String: Mappings]?
    let description: String?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    private enum CodingKeys: String, CodingKey {
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case conditions = "Conditions"
        case properties = "Properties"
        case transform = "Transform"
        case globals = "Globals"
        case outputs = "Outputs"
        case parameters = "Parameters"
        case resources = "Resources"
        case mappings = "Mappings"
        case description = "Description"
        case metadata = "Metadata"
    }
}

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    let method: String
    let path: String
    public struct RestApiIdObject: Codable, Sendable {
    }
    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case item(String)
        case itemObject(RestApiIdObject)
    }

    private enum CodingKeys: String, CodingKey {
        case method = "Method"
        case path = "Path"
        case restApiId = "RestApiId"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {

    public struct FilterPolicy: Codable, Sendable {
    }
    let filterPolicy: FilterPolicy?
    let region: String?
    let topic: String
    let filterPolicyScope: String?

    private enum CodingKeys: String, CodingKey {
        case filterPolicy = "FilterPolicy"
        case region = "Region"
        case topic = "Topic"
        case filterPolicyScope = "FilterPolicyScope"
    }
}

public struct Tag: Codable, Sendable {
    public struct ValueObject: Codable, Sendable {
    }
    let value: [String: Value]?

    public enum Value: Codable, Sendable {
        case item(String)
        case itemObject(ValueObject)
    }
    let key: String?

    private enum CodingKeys: String, CodingKey {
        case value = "Value"
        case key = "Key"
    }
}

public struct ServerlessFunctionMSKEvent: Codable, Sendable {
    let topics: [String]
    let startingPosition: String
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case topics = "Topics"
        case startingPosition = "StartingPosition"
        case stream = "Stream"
    }
}

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
}

public struct ServerlessApi: Codable, Sendable {
    let deletionPolicy: String?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let condition: String?

    public struct Properties: Codable, Sendable {
        public struct StageNameObject: Codable, Sendable {
        }
        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case item(String)
            case itemObject(StageNameObject)
        }
        public struct VariablesObject: Codable, Sendable {
        }
        let variables: [String: Variables]?

        public enum Variables: Codable, Sendable {
            case item(String)
            case itemObject(VariablesObject)
        }
        let description: String?
        let tracingEnabled: Bool?
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case item(String)
            case serverlessApiS3Location(ServerlessApiS3Location)
        }
        let name: String?

        public struct DefinitionBody: Codable, Sendable {
        }
        let definitionBody: DefinitionBody?
        let cacheClusterSize: String?
        let cacheClusterEnabled: Bool?

        private enum CodingKeys: String, CodingKey {
            case stageName = "StageName"
            case variables = "Variables"
            case description = "Description"
            case tracingEnabled = "TracingEnabled"
            case definitionUri = "DefinitionUri"
            case name = "Name"
            case definitionBody = "DefinitionBody"
            case cacheClusterSize = "CacheClusterSize"
            case cacheClusterEnabled = "CacheClusterEnabled"
        }
    }
    let properties: Properties
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }
    let updateReplacePolicy: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api

    private enum CodingKeys: String, CodingKey {
        case deletionPolicy = "DeletionPolicy"
        case metadata = "Metadata"
        case condition = "Condition"
        case properties = "Properties"
        case dependsOn = "DependsOn"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case type = "Type"
    }
}

public struct ServerlessFunction: Codable, Sendable {

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let condition: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function
    let updateReplacePolicy: String?
    let properties: [String: Properties]
    public struct Properties: Codable, Sendable {
        let inlineCode: String?
        let codeUri: [String: CodeUri]?

        public enum CodeUri: Codable, Sendable {
            case item(String)
            case serverlessFunctionS3Location(ServerlessFunctionS3Location)
        }
        let runtime: String
        let timeout: Double?
        let memorySize: Double?
        let tags: [String: String]?
        let description: String?
        let functionName: String?
        let handler: String
        let vpcConfig: ServerlessFunctionVpcConfig?
        public struct RoleObject: Codable, Sendable {
        }
        let role: [String: Role]?

        public enum Role: Codable, Sendable {
            case item(String)
            case itemObject(RoleObject)
        }
        let policies: [String: Policies]?

        public enum Policies: Codable, Sendable {
            case item(String)
            case itemArray([String])
            case serverlessFunctionIAMPolicyDocument(ServerlessFunctionIAMPolicyDocument)
            case serverlessFunctionIAMPolicyDocumentArray([ServerlessFunctionIAMPolicyDocument])
        }
        let tracing: String?
        let environment: ServerlessFunctionFunctionEnvironment?
        let deadLetterQueue: ServerlessFunctionDeadLetterQueue?
        let events: [String: ServerlessFunctionEventSource]?
        let kmsKeyArn: String?

        private enum CodingKeys: String, CodingKey {
            case inlineCode = "InlineCode"
            case codeUri = "CodeUri"
            case runtime = "Runtime"
            case timeout = "Timeout"
            case memorySize = "MemorySize"
            case tags = "Tags"
            case description = "Description"
            case functionName = "FunctionName"
            case handler = "Handler"
            case vpcConfig = "VpcConfig"
            case role = "Role"
            case policies = "Policies"
            case tracing = "Tracing"
            case environment = "Environment"
            case deadLetterQueue = "DeadLetterQueue"
            case events = "Events"
            case kmsKeyArn = "KmsKeyArn"
        }
    }
    let deletionPolicy: String?

    private enum CodingKeys: String, CodingKey {
        case metadata = "Metadata"
        case condition = "Condition"
        case dependsOn = "DependsOn"
        case type = "Type"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case properties = "Properties"
        case deletionPolicy = "DeletionPolicy"
    }
}

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let enabled: Bool?
    let startingPosition: String
    let stream: String
    let batchSize: Double

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case startingPosition = "StartingPosition"
        case stream = "Stream"
        case batchSize = "BatchSize"
    }
}

public struct ServerlessFunctionS3Location: Codable, Sendable {
    let key: String
    let version: Double?
    let bucket: String

    private enum CodingKeys: String, CodingKey {
        case key = "Key"
        case version = "Version"
        case bucket = "Bucket"
    }
}

public struct ServerlessFunctionDeadLetterQueue: Codable, Sendable {
    let targetArn: String
    let type: String

    private enum CodingKeys: String, CodingKey {
        case targetArn = "TargetArn"
        case type = "Type"
    }
}

public struct ServerlessFunctionCognitoEvent: Codable, Sendable {
    public struct UserPoolObject: Codable, Sendable {
    }
    let userPool: [String: UserPool]

    public enum UserPool: Codable, Sendable {
        case item(String)
        case itemObject(UserPoolObject)
    }
    let trigger: [String: Trigger]

    public enum Trigger: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    private enum CodingKeys: String, CodingKey {
        case userPool = "UserPool"
        case trigger = "Trigger"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let name: String?
    let enabled: Bool?
    let input: String?
    let schedule: String
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case enabled = "Enabled"
        case input = "Input"
        case schedule = "Schedule"
        case description = "Description"
    }
}

public struct Parameter: Codable, Sendable {

    public enum `Type`: String, Codable, Sendable {
        case string = "String"
        case number = "Number"
        case listNumber = "List<Number>"
        case commaDelimitedList = "CommaDelimitedList"
        case aws_EC2_Availabilityzone_Name = "AWS::EC2::AvailabilityZone::Name"
        case aws_EC2_Image_Id = "AWS::EC2::Image::Id"
        case aws_EC2_Instance_Id = "AWS::EC2::Instance::Id"
        case aws_EC2_Keypair_Keyname = "AWS::EC2::KeyPair::KeyName"
        case aws_EC2_Securitygroup_Groupname = "AWS::EC2::SecurityGroup::GroupName"
        case aws_EC2_Securitygroup_Id = "AWS::EC2::SecurityGroup::Id"
        case aws_EC2_Subnet_Id = "AWS::EC2::Subnet::Id"
        case aws_EC2_Volume_Id = "AWS::EC2::Volume::Id"
        case aws_EC2_VPC_Id = "AWS::EC2::VPC::Id"
        case aws_Route53_Hostedzone_Id = "AWS::Route53::HostedZone::Id"
        case listAWS_EC2_Availabilityzone_Name = "List<AWS::EC2::AvailabilityZone::Name>"
        case listAWS_EC2_Image_Id = "List<AWS::EC2::Image::Id>"
        case listAWS_EC2_Instance_Id = "List<AWS::EC2::Instance::Id>"
        case listAWS_EC2_Securitygroup_Groupname = "List<AWS::EC2::SecurityGroup::GroupName>"
        case listAWS_EC2_Securitygroup_Id = "List<AWS::EC2::SecurityGroup::Id>"
        case listAWS_EC2_Subnet_Id = "List<AWS::EC2::Subnet::Id>"
        case listAWS_EC2_Volume_Id = "List<AWS::EC2::Volume::Id>"
        case listAWS_EC2_VPC_Id = "List<AWS::EC2::VPC::Id>"
        case listAWS_Route53_Hostedzone_Id = "List<AWS::Route53::HostedZone::Id>"
        case listString = "List<String>"
    }
    let type: `Type` = .string
    let maxValue: String?
    let noEcho: NoEcho?

    public enum NoEcho: Codable, Sendable {
        case string(String)
        case boolean(Bool)
    }
    let `default`: String?
    let description: String?
    let minValue: String?
    let maxLength: String?
    let allowedPattern: String?
    let minLength: String?
    let constraintDescription: String?
    let allowedValues: [String]?

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case maxValue = "MaxValue"
        case noEcho = "NoEcho"
        case `default` = "Default"
        case description = "Description"
        case minValue = "MinValue"
        case maxLength = "MaxLength"
        case allowedPattern = "AllowedPattern"
        case minLength = "MinLength"
        case constraintDescription = "ConstraintDescription"
        case allowedValues = "AllowedValues"
    }
}

public struct ServerlessFunctionEventSource: Codable, Sendable {
    let properties: [String: Properties]

    public enum Properties: Codable, Sendable {
        case serverlessFunctionS3Event(ServerlessFunctionS3Event)
        case serverlessFunctionSNSEvent(ServerlessFunctionSNSEvent)
        case serverlessFunctionKinesisEvent(ServerlessFunctionKinesisEvent)
        case serverlessFunctionMSKEvent(ServerlessFunctionMSKEvent)
        case serverlessFunctionMQEvent(ServerlessFunctionMQEvent)
        case serverlessFunctionSQSEvent(ServerlessFunctionSQSEvent)
        case serverlessFunctionDynamoDBEvent(ServerlessFunctionDynamoDBEvent)
        case serverlessFunctionApiEvent(ServerlessFunctionApiEvent)
        case serverlessFunctionScheduleEvent(ServerlessFunctionScheduleEvent)
        case serverlessFunctionCloudWatchEventEvent(ServerlessFunctionCloudWatchEventEvent)
        case serverlessFunctionEventBridgeRule(ServerlessFunctionEventBridgeRule)
        case serverlessFunctionLogEvent(ServerlessFunctionLogEvent)
        case serverlessFunctionIoTRuleEvent(ServerlessFunctionIoTRuleEvent)
        case serverlessFunctionAlexaSkillEvent(ServerlessFunctionAlexaSkillEvent)
        case serverlessFunctionCognitoEvent(ServerlessFunctionCognitoEvent)
    }
    let type: String

    private enum CodingKeys: String, CodingKey {
        case properties = "Properties"
        case type = "Type"
    }
}

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: [String: String]

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessSimpleTablePrimaryKey: Codable, Sendable {
    let type: String
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case name = "Name"
    }
}

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let batchSize: Double?
    let stream: String
    let enabled: Bool?
    let startingPosition: String

    private enum CodingKeys: String, CodingKey {
        case batchSize = "BatchSize"
        case stream = "Stream"
        case enabled = "Enabled"
        case startingPosition = "StartingPosition"
    }
}

public struct ServerlessApiS3Location: Codable, Sendable {
    let key: String
    let version: Double?
    let bucket: String

    private enum CodingKeys: String, CodingKey {
        case key = "Key"
        case version = "Version"
        case bucket = "Bucket"
    }
}

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
    }
}

public struct ServerlessFunctionIoTRuleEvent: Codable, Sendable {
    let sql: String
    let awsIotSqlVersion: String?

    private enum CodingKeys: String, CodingKey {
        case sql = "Sql"
        case awsIotSqlVersion = "AwsIotSqlVersion"
    }
}

public struct ServerlessFunctionVpcConfig: Codable, Sendable {
    let subnetIds: [String]
    let securityGroupIds: [String]

    public struct SubnetIdsUsingRef: Codable, Sendable {
    }
    let subnetIdsUsingRef: [SubnetIdsUsingRef]?

    private enum CodingKeys: String, CodingKey {
        case subnetIds = "SubnetIds"
        case securityGroupIds = "SecurityGroupIds"
        case subnetIdsUsingRef = "SubnetIdsUsingRef"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let input: String?
    let inputPath: String?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let eventBusName: String?

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case inputPath = "InputPath"
        case pattern = "Pattern"
        case eventBusName = "EventBusName"
    }
}

public struct ServerlessSimpleTable: Codable, Sendable {
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }
    let updateReplacePolicy: String?

    public struct Properties: Codable, Sendable {
        let sseSpecification: ServerlessSimpleTableSSESpecification?
        let primaryKey: ServerlessSimpleTablePrimaryKey?
        let provisionedThroughput: ServerlessSimpleTableProvisionedThroughput?

        private enum CodingKeys: String, CodingKey {
            case sseSpecification = "SSESpecification"
            case primaryKey = "PrimaryKey"
            case provisionedThroughput = "ProvisionedThroughput"
        }
    }
    let properties: Properties?
    let condition: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let deletionPolicy: String?

    private enum CodingKeys: String, CodingKey {
        case dependsOn = "DependsOn"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case properties = "Properties"
        case condition = "Condition"
        case type = "Type"
        case metadata = "Metadata"
        case deletionPolicy = "DeletionPolicy"
    }
}

public struct ServerlessFunctionMQEvent: Codable, Sendable {
    let sourceAccessConfigurations: [String]
    let queues: [String]
    let broker: String

    private enum CodingKeys: String, CodingKey {
        case sourceAccessConfigurations = "SourceAccessConfigurations"
        case queues = "Queues"
        case broker = "Broker"
    }
}

public struct ServerlessFunctionS3Event: Codable, Sendable {
    let filter: ServerlessFunctionS3NotificationFilter?
    public struct BucketObject: Codable, Sendable {
    }
    let bucket: [String: Bucket]

    public enum Bucket: Codable, Sendable {
        case item(String)
        case itemObject(BucketObject)
    }
    let events: [String: Events]

    public enum Events: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    private enum CodingKeys: String, CodingKey {
        case filter = "Filter"
        case bucket = "Bucket"
        case events = "Events"
    }
}

public struct ServerlessFunctionS3NotificationFilter: Codable, Sendable {
    public struct S3KeyObject: Codable, Sendable {
    }
    let s3Key: [String: S3Key]

    public enum S3Key: Codable, Sendable {
        case item(String)
        case itemObject(S3KeyObject)
    }

    private enum CodingKeys: String, CodingKey {
        case s3Key = "S3Key"
    }
}

public struct ServerlessFunctionLogEvent: Codable, Sendable {
    let logGroupName: String
    let filterPattern: String

    private enum CodingKeys: String, CodingKey {
        case logGroupName = "LogGroupName"
        case filterPattern = "FilterPattern"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {

    public struct DeadLetterConfig: Codable, Sendable {
        let queueLogicalId: String?
        let type: String?
        let arn: String?

        private enum CodingKeys: String, CodingKey {
            case queueLogicalId = "QueueLogicalId"
            case type = "Type"
            case arn = "Arn"
        }
    }
    let deadLetterConfig: DeadLetterConfig?

    public struct RetryPolicy: Codable, Sendable {
        let maximumEventAgeInSeconds: Double?
        let maximumRetryAttempts: Double?

        private enum CodingKeys: String, CodingKey {
            case maximumEventAgeInSeconds = "MaximumEventAgeInSeconds"
            case maximumRetryAttempts = "MaximumRetryAttempts"
        }
    }
    let retryPolicy: RetryPolicy?
    let state: String?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let input: String?
    let inputPath: String?
    let ruleName: String?

    private enum CodingKeys: String, CodingKey {
        case deadLetterConfig = "DeadLetterConfig"
        case retryPolicy = "RetryPolicy"
        case state = "State"
        case pattern = "Pattern"
        case input = "Input"
        case inputPath = "InputPath"
        case ruleName = "RuleName"
    }
}

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    let enabled: Bool?
    let batchSize: Double?
    public struct QueueObject: Codable, Sendable {
    }
    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case item(String)
        case itemObject(QueueObject)
    }

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case batchSize = "BatchSize"
        case queue = "Queue"
    }
}

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {

    public struct Statement: Codable, Sendable {
    }
    let statement: [Statement]

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
    }
}

public struct ServerlessSimpleTableProvisionedThroughput: Codable, Sendable {
    let readCapacityUnits: Double?
    let writeCapacityUnits: Double

    private enum CodingKeys: String, CodingKey {
        case readCapacityUnits = "ReadCapacityUnits"
        case writeCapacityUnits = "WriteCapacityUnits"
    }
}