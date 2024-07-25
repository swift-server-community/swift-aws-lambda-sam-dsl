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

    public struct Metadata: Codable, Sendable {}

    let metadata: Metadata?

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09

    public struct Globals: Codable, Sendable {}

    let globals: Globals?

    public struct Outputs: Codable, Sendable {}

    let outputs: [String: Outputs]?
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }

    let description: String?

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    let transform: Transform? = .aws_Serverless_2016_10_31

    public struct Properties: Codable, Sendable {}

    let properties: Properties?

    public struct Conditions: Codable, Sendable {}

    let conditions: [String: Conditions]?

    public struct Mappings: Codable, Sendable {}

    let mappings: [String: Mappings]?

    private enum CodingKeys: String, CodingKey {
        case parameters = "Parameters"
        case metadata = "Metadata"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case globals = "Globals"
        case outputs = "Outputs"
        case resources = "Resources"
        case description = "Description"
        case transform = "Transform"
        case properties = "Properties"
        case conditions = "Conditions"
        case mappings = "Mappings"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    public struct Pattern: Codable, Sendable {}

    let pattern: Pattern
    let input: String?
    let eventBusName: String?
    let inputPath: String?

    private enum CodingKeys: String, CodingKey {
        case pattern = "Pattern"
        case input = "Input"
        case eventBusName = "EventBusName"
        case inputPath = "InputPath"
    }
}

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: [String: String]

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessApi: Codable, Sendable {
    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }

    let type: `Type` = .aws_Serverless_Api

    public struct Properties: Codable, Sendable {
        let description: String?
        public struct StageNameObject: Codable, Sendable {}

        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case item(String)
            case itemObject(StageNameObject)
        }

        let name: String?
        public struct VariablesObject: Codable, Sendable {}

        let variables: [String: Variables]?

        public enum Variables: Codable, Sendable {
            case item(String)
            case itemObject(VariablesObject)
        }

        let tracingEnabled: Bool?
        let cacheClusterEnabled: Bool?
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case item(String)
            case serverlessApiS3Location(ServerlessApiS3Location)
        }

        let cacheClusterSize: String?

        public struct DefinitionBody: Codable, Sendable {}

        let definitionBody: DefinitionBody?

        private enum CodingKeys: String, CodingKey {
            case description = "Description"
            case stageName = "StageName"
            case name = "Name"
            case variables = "Variables"
            case tracingEnabled = "TracingEnabled"
            case cacheClusterEnabled = "CacheClusterEnabled"
            case definitionUri = "DefinitionUri"
            case cacheClusterSize = "CacheClusterSize"
            case definitionBody = "DefinitionBody"
        }
    }

    let properties: Properties

    public struct Metadata: Codable, Sendable {}

    let metadata: Metadata?
    let updateReplacePolicy: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    let condition: String?
    let deletionPolicy: String?

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case properties = "Properties"
        case metadata = "Metadata"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case dependsOn = "DependsOn"
        case condition = "Condition"
        case deletionPolicy = "DeletionPolicy"
    }
}

public struct Parameter: Codable, Sendable {
    let allowedValues: [String]?
    let allowedPattern: String?

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
    let noEcho: NoEcho?

    public enum NoEcho: Codable, Sendable {
        case string(String)
        case boolean(Bool)
    }

    let constraintDescription: String?
    let `default`: String?
    let description: String?
    let maxValue: String?
    let maxLength: String?
    let minValue: String?
    let minLength: String?

    private enum CodingKeys: String, CodingKey {
        case allowedValues = "AllowedValues"
        case allowedPattern = "AllowedPattern"
        case type = "Type"
        case noEcho = "NoEcho"
        case constraintDescription = "ConstraintDescription"
        case `default` = "Default"
        case description = "Description"
        case maxValue = "MaxValue"
        case maxLength = "MaxLength"
        case minValue = "MinValue"
        case minLength = "MinLength"
    }
}

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let enabled: Bool?
    let startingPosition: String
    let stream: String
    let batchSize: Double?

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case startingPosition = "StartingPosition"
        case stream = "Stream"
        case batchSize = "BatchSize"
    }
}

public struct ServerlessFunctionS3NotificationFilter: Codable, Sendable {
    public struct S3KeyObject: Codable, Sendable {}

    let s3Key: [String: S3Key]

    public enum S3Key: Codable, Sendable {
        case item(String)
        case itemObject(S3KeyObject)
    }

    private enum CodingKeys: String, CodingKey {
        case s3Key = "S3Key"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
    public struct Pattern: Codable, Sendable {}

    let pattern: Pattern

    public struct RetryPolicy: Codable, Sendable {
        let maximumEventAgeInSeconds: Double?
        let maximumRetryAttempts: Double?

        private enum CodingKeys: String, CodingKey {
            case maximumEventAgeInSeconds = "MaximumEventAgeInSeconds"
            case maximumRetryAttempts = "MaximumRetryAttempts"
        }
    }

    let retryPolicy: RetryPolicy?
    let ruleName: String?
    let state: String?

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
    let input: String?
    let inputPath: String?

    private enum CodingKeys: String, CodingKey {
        case pattern = "Pattern"
        case retryPolicy = "RetryPolicy"
        case ruleName = "RuleName"
        case state = "State"
        case deadLetterConfig = "DeadLetterConfig"
        case input = "Input"
        case inputPath = "InputPath"
    }
}

public struct ServerlessFunctionCognitoEvent: Codable, Sendable {
    public struct UserPoolObject: Codable, Sendable {}

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

public struct ServerlessFunctionMSKEvent: Codable, Sendable {
    let stream: String
    let startingPosition: String
    let topics: [String]

    private enum CodingKeys: String, CodingKey {
        case stream = "Stream"
        case startingPosition = "StartingPosition"
        case topics = "Topics"
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

public struct ServerlessFunction: Codable, Sendable {
    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }

    let type: `Type` = .aws_Serverless_Function

    public struct Metadata: Codable, Sendable {}

    let metadata: Metadata?
    let updateReplacePolicy: String?
    let deletionPolicy: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    let properties: [String: Properties]
    public struct Properties: Codable, Sendable {
        let inlineCode: String?
        let codeUri: [String: CodeUri]?

        public enum CodeUri: Codable, Sendable {
            case item(String)
            case serverlessFunctionS3Location(ServerlessFunctionS3Location)
        }

        let runtime: String
        let memorySize: Double?
        let description: String?
        let kmsKeyArn: String?
        let environment: ServerlessFunctionFunctionEnvironment?
        let policies: [String: Policies]?

        public enum Policies: Codable, Sendable {
            case item(String)
            case itemArray([String])
            case serverlessFunctionIAMPolicyDocument(ServerlessFunctionIAMPolicyDocument)
            case serverlessFunctionIAMPolicyDocumentArray([ServerlessFunctionIAMPolicyDocument])
        }

        let tracing: String?
        let tags: [String: String]?
        public struct RoleObject: Codable, Sendable {}

        let role: [String: Role]?

        public enum Role: Codable, Sendable {
            case item(String)
            case itemObject(RoleObject)
        }

        let functionName: String?
        let deadLetterQueue: ServerlessFunctionDeadLetterQueue?
        let handler: String
        let events: [String: ServerlessFunctionEventSource]?
        let timeout: Double?
        let vpcConfig: ServerlessFunctionVpcConfig?

        private enum CodingKeys: String, CodingKey {
            case inlineCode = "InlineCode"
            case codeUri = "CodeUri"
            case runtime = "Runtime"
            case memorySize = "MemorySize"
            case description = "Description"
            case kmsKeyArn = "KmsKeyArn"
            case environment = "Environment"
            case policies = "Policies"
            case tracing = "Tracing"
            case tags = "Tags"
            case role = "Role"
            case functionName = "FunctionName"
            case deadLetterQueue = "DeadLetterQueue"
            case handler = "Handler"
            case events = "Events"
            case timeout = "Timeout"
            case vpcConfig = "VpcConfig"
        }
    }

    let condition: String?

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case metadata = "Metadata"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case deletionPolicy = "DeletionPolicy"
        case dependsOn = "DependsOn"
        case properties = "Properties"
        case condition = "Condition"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {
    let filterPolicyScope: String?
    let topic: String

    public struct FilterPolicy: Codable, Sendable {}

    let filterPolicy: FilterPolicy?
    let region: String?

    private enum CodingKeys: String, CodingKey {
        case filterPolicyScope = "FilterPolicyScope"
        case topic = "Topic"
        case filterPolicy = "FilterPolicy"
        case region = "Region"
    }
}

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    let batchSize: Double?
    let enabled: Bool?
    public struct QueueObject: Codable, Sendable {}

    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case item(String)
        case itemObject(QueueObject)
    }

    private enum CodingKeys: String, CodingKey {
        case batchSize = "BatchSize"
        case enabled = "Enabled"
        case queue = "Queue"
    }
}

public struct ServerlessFunctionLogEvent: Codable, Sendable {
    let filterPattern: String
    let logGroupName: String

    private enum CodingKeys: String, CodingKey {
        case filterPattern = "FilterPattern"
        case logGroupName = "LogGroupName"
    }
}

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
}

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {
    public struct Statement: Codable, Sendable {}

    let statement: [Statement]

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
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

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct Tag: Codable, Sendable {
    public struct ValueObject: Codable, Sendable {}

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

public struct ServerlessFunctionVpcConfig: Codable, Sendable {
    let securityGroupIds: [String]

    public struct SubnetIdsUsingRef: Codable, Sendable {}

    let subnetIdsUsingRef: [SubnetIdsUsingRef]?
    let subnetIds: [String]

    private enum CodingKeys: String, CodingKey {
        case securityGroupIds = "SecurityGroupIds"
        case subnetIdsUsingRef = "SubnetIdsUsingRef"
        case subnetIds = "SubnetIds"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let schedule: String
    let input: String?
    let description: String?
    let enabled: Bool?
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case schedule = "Schedule"
        case input = "Input"
        case description = "Description"
        case enabled = "Enabled"
        case name = "Name"
    }
}

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
    }
}

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    public struct RestApiIdObject: Codable, Sendable {}

    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case item(String)
        case itemObject(RestApiIdObject)
    }

    let path: String
    let method: String

    private enum CodingKeys: String, CodingKey {
        case restApiId = "RestApiId"
        case path = "Path"
        case method = "Method"
    }
}

public struct ServerlessSimpleTablePrimaryKey: Codable, Sendable {
    let name: String?
    let type: String

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
    }
}

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let startingPosition: String
    let enabled: Bool?
    let batchSize: Double
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case startingPosition = "StartingPosition"
        case enabled = "Enabled"
        case batchSize = "BatchSize"
        case stream = "Stream"
    }
}

public struct ServerlessFunctionMQEvent: Codable, Sendable {
    let queues: [String]
    let broker: String
    let sourceAccessConfigurations: [String]

    private enum CodingKeys: String, CodingKey {
        case queues = "Queues"
        case broker = "Broker"
        case sourceAccessConfigurations = "SourceAccessConfigurations"
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

public struct ServerlessSimpleTable: Codable, Sendable {
    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }

    let type: `Type` = .aws_Serverless_Simpletable
    let condition: String?
    let deletionPolicy: String?
    let updateReplacePolicy: String?

    public struct Metadata: Codable, Sendable {}

    let metadata: Metadata?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    public struct Properties: Codable, Sendable {
        let sseSpecification: ServerlessSimpleTableSSESpecification?
        let provisionedThroughput: ServerlessSimpleTableProvisionedThroughput?
        let primaryKey: ServerlessSimpleTablePrimaryKey?

        private enum CodingKeys: String, CodingKey {
            case sseSpecification = "SSESpecification"
            case provisionedThroughput = "ProvisionedThroughput"
            case primaryKey = "PrimaryKey"
        }
    }

    let properties: Properties?

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case condition = "Condition"
        case deletionPolicy = "DeletionPolicy"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case metadata = "Metadata"
        case dependsOn = "DependsOn"
        case properties = "Properties"
    }
}

public struct ServerlessFunctionS3Location: Codable, Sendable {
    let bucket: String
    let key: String
    let version: Double?

    private enum CodingKeys: String, CodingKey {
        case bucket = "Bucket"
        case key = "Key"
        case version = "Version"
    }
}

public struct ServerlessFunctionS3Event: Codable, Sendable {
    let filter: ServerlessFunctionS3NotificationFilter?
    public struct BucketObject: Codable, Sendable {}

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
