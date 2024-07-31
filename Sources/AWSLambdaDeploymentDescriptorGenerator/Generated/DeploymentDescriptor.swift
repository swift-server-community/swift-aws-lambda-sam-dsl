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
    let parameters: [String: Parameter]?

    public struct Outputs: Codable, Sendable {
    }
    let outputs: [String: Outputs]?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }
    let transform: Transform? = .aws_Serverless_2016_10_31

    public struct Mappings: Codable, Sendable {
    }
    let mappings: [String: Mappings]?

    public struct Globals: Codable, Sendable {
    }
    let globals: Globals?

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }

    public struct Conditions: Codable, Sendable {
    }
    let conditions: [String: Conditions]?

    public struct Properties: Codable, Sendable {
    }
    let properties: Properties?
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case parameters = "Parameters"
        case outputs = "Outputs"
        case metadata = "Metadata"
        case transform = "Transform"
        case mappings = "Mappings"
        case globals = "Globals"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case resources = "Resources"
        case conditions = "Conditions"
        case properties = "Properties"
        case description = "Description"
    }
}

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let enabled: Bool?
    let stream: String
    let batchSize: Double
    let startingPosition: String

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case stream = "Stream"
        case batchSize = "BatchSize"
        case startingPosition = "StartingPosition"
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

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    public struct RestApiIdObject: Codable, Sendable {
    }
    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case item(String)
        case itemObject(RestApiIdObject)
    }
    let method: String
    let path: String

    private enum CodingKeys: String, CodingKey {
        case restApiId = "RestApiId"
        case method = "Method"
        case path = "Path"
    }
}

public struct ServerlessApi: Codable, Sendable {
    let deletionPolicy: String?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api
    let updateReplacePolicy: String?

    public struct Properties: Codable, Sendable {
        let tracingEnabled: Bool?
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case item(String)
            case serverlessApiS3Location(ServerlessApiS3Location)
        }
        let cacheClusterEnabled: Bool?
        let name: String?
        public struct VariablesObject: Codable, Sendable {
        }
        let variables: [String: Variables]?

        public enum Variables: Codable, Sendable {
            case item(String)
            case itemObject(VariablesObject)
        }
        let cacheClusterSize: String?
        let description: String?

        public struct DefinitionBody: Codable, Sendable {
        }
        let definitionBody: DefinitionBody?
        public struct StageNameObject: Codable, Sendable {
        }
        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case item(String)
            case itemObject(StageNameObject)
        }

        private enum CodingKeys: String, CodingKey {
            case tracingEnabled = "TracingEnabled"
            case definitionUri = "DefinitionUri"
            case cacheClusterEnabled = "CacheClusterEnabled"
            case name = "Name"
            case variables = "Variables"
            case cacheClusterSize = "CacheClusterSize"
            case description = "Description"
            case definitionBody = "DefinitionBody"
            case stageName = "StageName"
        }
    }
    let properties: Properties
    let condition: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    private enum CodingKeys: String, CodingKey {
        case deletionPolicy = "DeletionPolicy"
        case metadata = "Metadata"
        case type = "Type"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case properties = "Properties"
        case condition = "Condition"
        case dependsOn = "DependsOn"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let input: String?
    let eventBusName: String?
    let inputPath: String?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case eventBusName = "EventBusName"
        case inputPath = "InputPath"
        case pattern = "Pattern"
    }
}

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: [String: String]

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessFunction: Codable, Sendable {
    let condition: String?
    let properties: [String: Properties]
    public struct Properties: Codable, Sendable {
        let inlineCode: String?
        let codeUri: [String: CodeUri]?

        public enum CodeUri: Codable, Sendable {
            case item(String)
            case serverlessFunctionS3Location(ServerlessFunctionS3Location)
        }
        let description: String?
        let policies: [String: Policies]?

        public enum Policies: Codable, Sendable {
            case item(String)
            case itemArray([String])
            case serverlessFunctionIAMPolicyDocument(ServerlessFunctionIAMPolicyDocument)
            case serverlessFunctionIAMPolicyDocumentArray([ServerlessFunctionIAMPolicyDocument])
        }
        public struct RoleObject: Codable, Sendable {
        }
        let role: [String: Role]?

        public enum Role: Codable, Sendable {
            case item(String)
            case itemObject(RoleObject)
        }
        let tracing: String?
        let runtime: String
        let functionName: String?
        let events: [String: ServerlessFunctionEventSource]?
        let handler: String
        let deadLetterQueue: ServerlessFunctionDeadLetterQueue?
        let memorySize: Double?
        let vpcConfig: ServerlessFunctionVpcConfig?
        let kmsKeyArn: String?
        let tags: [String: String]?
        let environment: ServerlessFunctionFunctionEnvironment?
        let timeout: Double?

        private enum CodingKeys: String, CodingKey {
            case inlineCode = "InlineCode"
            case codeUri = "CodeUri"
            case description = "Description"
            case policies = "Policies"
            case role = "Role"
            case tracing = "Tracing"
            case runtime = "Runtime"
            case functionName = "FunctionName"
            case events = "Events"
            case handler = "Handler"
            case deadLetterQueue = "DeadLetterQueue"
            case memorySize = "MemorySize"
            case vpcConfig = "VpcConfig"
            case kmsKeyArn = "KmsKeyArn"
            case tags = "Tags"
            case environment = "Environment"
            case timeout = "Timeout"
        }
    }

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let deletionPolicy: String?
    let updateReplacePolicy: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function

    private enum CodingKeys: String, CodingKey {
        case condition = "Condition"
        case properties = "Properties"
        case metadata = "Metadata"
        case deletionPolicy = "DeletionPolicy"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case dependsOn = "DependsOn"
        case type = "Type"
    }
}

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    let batchSize: Double?
    public struct QueueObject: Codable, Sendable {
    }
    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case item(String)
        case itemObject(QueueObject)
    }
    let enabled: Bool?

    private enum CodingKeys: String, CodingKey {
        case batchSize = "BatchSize"
        case queue = "Queue"
        case enabled = "Enabled"
    }
}

public struct ServerlessFunctionS3Event: Codable, Sendable {
    let events: [String: Events]

    public enum Events: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }
    let filter: ServerlessFunctionS3NotificationFilter?
    public struct BucketObject: Codable, Sendable {
    }
    let bucket: [String: Bucket]

    public enum Bucket: Codable, Sendable {
        case item(String)
        case itemObject(BucketObject)
    }

    private enum CodingKeys: String, CodingKey {
        case events = "Events"
        case filter = "Filter"
        case bucket = "Bucket"
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

public struct ServerlessFunctionS3Location: Codable, Sendable {
    let version: Double?
    let bucket: String
    let key: String

    private enum CodingKeys: String, CodingKey {
        case version = "Version"
        case bucket = "Bucket"
        case key = "Key"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {
    let filterPolicyScope: String?
    let topic: String

    public struct FilterPolicy: Codable, Sendable {
    }
    let filterPolicy: FilterPolicy?
    let region: String?

    private enum CodingKeys: String, CodingKey {
        case filterPolicyScope = "FilterPolicyScope"
        case topic = "Topic"
        case filterPolicy = "FilterPolicy"
        case region = "Region"
    }
}

public struct ServerlessApiS3Location: Codable, Sendable {
    let version: Double?
    let key: String
    let bucket: String

    private enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case bucket = "Bucket"
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

public struct ServerlessFunctionMQEvent: Codable, Sendable {
    let queues: [String]
    let sourceAccessConfigurations: [String]
    let broker: String

    private enum CodingKeys: String, CodingKey {
        case queues = "Queues"
        case sourceAccessConfigurations = "SourceAccessConfigurations"
        case broker = "Broker"
    }
}

public struct ServerlessSimpleTable: Codable, Sendable {
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    public struct Properties: Codable, Sendable {
        let provisionedThroughput: ServerlessSimpleTableProvisionedThroughput?
        let sseSpecification: ServerlessSimpleTableSSESpecification?
        let primaryKey: ServerlessSimpleTablePrimaryKey?

        private enum CodingKeys: String, CodingKey {
            case provisionedThroughput = "ProvisionedThroughput"
            case sseSpecification = "SSESpecification"
            case primaryKey = "PrimaryKey"
        }
    }
    let properties: Properties?
    let deletionPolicy: String?
    let condition: String?
    let updateReplacePolicy: String?

    private enum CodingKeys: String, CodingKey {
        case dependsOn = "DependsOn"
        case type = "Type"
        case metadata = "Metadata"
        case properties = "Properties"
        case deletionPolicy = "DeletionPolicy"
        case condition = "Condition"
        case updateReplacePolicy = "UpdateReplacePolicy"
    }
}

public struct Parameter: Codable, Sendable {
    let allowedPattern: String?
    let minValue: String?

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
    let constraintDescription: String?
    let allowedValues: [String]?
    let description: String?
    let noEcho: NoEcho?

    public enum NoEcho: Codable, Sendable {
        case string(String)
        case boolean(Bool)
    }
    let maxLength: String?
    let minLength: String?
    let `default`: String?
    let maxValue: String?

    private enum CodingKeys: String, CodingKey {
        case allowedPattern = "AllowedPattern"
        case minValue = "MinValue"
        case type = "Type"
        case constraintDescription = "ConstraintDescription"
        case allowedValues = "AllowedValues"
        case description = "Description"
        case noEcho = "NoEcho"
        case maxLength = "MaxLength"
        case minLength = "MinLength"
        case `default` = "Default"
        case maxValue = "MaxValue"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
    let input: String?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let inputPath: String?
    let ruleName: String?
    let state: String?

    public struct DeadLetterConfig: Codable, Sendable {
        let arn: String?
        let queueLogicalId: String?
        let type: String?

        private enum CodingKeys: String, CodingKey {
            case arn = "Arn"
            case queueLogicalId = "QueueLogicalId"
            case type = "Type"
        }
    }
    let deadLetterConfig: DeadLetterConfig?

    public struct RetryPolicy: Codable, Sendable {
        let maximumRetryAttempts: Double?
        let maximumEventAgeInSeconds: Double?

        private enum CodingKeys: String, CodingKey {
            case maximumRetryAttempts = "MaximumRetryAttempts"
            case maximumEventAgeInSeconds = "MaximumEventAgeInSeconds"
        }
    }
    let retryPolicy: RetryPolicy?

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case pattern = "Pattern"
        case inputPath = "InputPath"
        case ruleName = "RuleName"
        case state = "State"
        case deadLetterConfig = "DeadLetterConfig"
        case retryPolicy = "RetryPolicy"
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

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let stream: String
    let startingPosition: String
    let enabled: Bool?
    let batchSize: Double?

    private enum CodingKeys: String, CodingKey {
        case stream = "Stream"
        case startingPosition = "StartingPosition"
        case enabled = "Enabled"
        case batchSize = "BatchSize"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let description: String?
    let enabled: Bool?
    let name: String?
    let schedule: String
    let input: String?

    private enum CodingKeys: String, CodingKey {
        case description = "Description"
        case enabled = "Enabled"
        case name = "Name"
        case schedule = "Schedule"
        case input = "Input"
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

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
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

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
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

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}