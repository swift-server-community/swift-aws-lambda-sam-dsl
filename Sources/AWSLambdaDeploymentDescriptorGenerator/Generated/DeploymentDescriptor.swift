
public struct SAMDeploymentDescriptor: Codable, Sendable {
    let conditions: [String: Conditions]?

    public struct Conditions: Codable, Sendable {
    }
    let transform: Transform? = .aws_Serverless_2016_10_31
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09
    let outputs: [String: Outputs]?

    public struct Outputs: Codable, Sendable {
    }
    let mappings: [String: Mappings]?

    public struct Mappings: Codable, Sendable {
    }
    let parameters: [String: Parameter]?
    let description: String?
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
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
        case conditions = "Conditions"
        case transform = "Transform"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case outputs = "Outputs"
        case mappings = "Mappings"
        case parameters = "Parameters"
        case description = "Description"
        case resources = "Resources"
    }
}

public struct ServerlessFunctionCognitoEvent: Codable, Sendable {
    let trigger: [String: Trigger]

    public enum Trigger: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    public struct UserPoolObject: Codable, Sendable {
    }
    let userPool: [String: UserPool]

    public enum UserPool: Codable, Sendable {
        case itemString(String)
        case itemObject(UserPoolObject)
    }

    private enum CodingKeys: String, CodingKey {
        case trigger = "Trigger"
        case userPool = "UserPool"
    }
}

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
}

public struct ServerlessApi: Codable, Sendable {

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let updateReplacePolicy: String?
    let condition: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }

    public struct Properties: Codable, Sendable {
        let name: String?
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case itemString(String)
            case serverlessApiS3Location(ServerlessApiS3Location)
        }

        public struct DefinitionBody: Codable, Sendable {
        }
        let definitionBody: DefinitionBody?
        let description: String?
        public struct StageNameObject: Codable, Sendable {
        }
        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case itemString(String)
            case itemObject(StageNameObject)
        }
        let tracingEnabled: Bool?
        public struct VariablesObject: Codable, Sendable {
        }
        let variables: [String: Variables]?

        public enum Variables: Codable, Sendable {
            case itemString(String)
            case itemObject(VariablesObject)
        }
        let cacheClusterSize: String?
        let cacheClusterEnabled: Bool?

        private enum CodingKeys: String, CodingKey {
            case name = "Name"
            case definitionUri = "DefinitionUri"
            case definitionBody = "DefinitionBody"
            case description = "Description"
            case stageName = "StageName"
            case tracingEnabled = "TracingEnabled"
            case variables = "Variables"
            case cacheClusterSize = "CacheClusterSize"
            case cacheClusterEnabled = "CacheClusterEnabled"
        }
    }
    let properties: Properties
    let deletionPolicy: String?

    private enum CodingKeys: String, CodingKey {
        case metadata = "Metadata"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case condition = "Condition"
        case type = "Type"
        case dependsOn = "DependsOn"
        case properties = "Properties"
        case deletionPolicy = "DeletionPolicy"
    }
}

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let stream: String
    let startingPosition: String
    let enabled: Bool?
    let batchSize: Double

    private enum CodingKeys: String, CodingKey {
        case stream = "Stream"
        case startingPosition = "StartingPosition"
        case enabled = "Enabled"
        case batchSize = "BatchSize"
    }
}

public struct ServerlessSimpleTable: Codable, Sendable {
    let condition: String?
    let updateReplacePolicy: String?
    let deletionPolicy: String?

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
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable

    private enum CodingKeys: String, CodingKey {
        case condition = "Condition"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case deletionPolicy = "DeletionPolicy"
        case properties = "Properties"
        case dependsOn = "DependsOn"
        case metadata = "Metadata"
        case type = "Type"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
    let state: String?

    public struct DeadLetterConfig: Codable, Sendable {
        let type: String?
        let queueLogicalId: String?
        let arn: String?

        private enum CodingKeys: String, CodingKey {
            case type = "Type"
            case queueLogicalId = "QueueLogicalId"
            case arn = "Arn"
        }
    }
    let deadLetterConfig: DeadLetterConfig?
    let inputPath: String?
    let input: String?
    let ruleName: String?

    public struct RetryPolicy: Codable, Sendable {
        let maximumEventAgeInSeconds: Double?
        let maximumRetryAttempts: Double?

        private enum CodingKeys: String, CodingKey {
            case maximumEventAgeInSeconds = "MaximumEventAgeInSeconds"
            case maximumRetryAttempts = "MaximumRetryAttempts"
        }
    }
    let retryPolicy: RetryPolicy?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern

    private enum CodingKeys: String, CodingKey {
        case state = "State"
        case deadLetterConfig = "DeadLetterConfig"
        case inputPath = "InputPath"
        case input = "Input"
        case ruleName = "RuleName"
        case retryPolicy = "RetryPolicy"
        case pattern = "Pattern"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let input: String?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let eventBusName: String?
    let inputPath: String?

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case pattern = "Pattern"
        case eventBusName = "EventBusName"
        case inputPath = "InputPath"
    }
}

public struct ServerlessFunctionS3Event: Codable, Sendable {
    public struct BucketObject: Codable, Sendable {
    }
    let bucket: [String: Bucket]

    public enum Bucket: Codable, Sendable {
        case itemString(String)
        case itemObject(BucketObject)
    }
    let events: [String: Events]

    public enum Events: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    let filter: ServerlessFunctionS3NotificationFilter?

    private enum CodingKeys: String, CodingKey {
        case bucket = "Bucket"
        case events = "Events"
        case filter = "Filter"
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

public struct ServerlessFunctionMQEvent: Codable, Sendable {
    let broker: String
    let queues: [String]
    let sourceAccessConfigurations: [String]

    private enum CodingKeys: String, CodingKey {
        case broker = "Broker"
        case queues = "Queues"
        case sourceAccessConfigurations = "SourceAccessConfigurations"
    }
}

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {
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

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct ServerlessFunctionVpcConfig: Codable, Sendable {
    let securityGroupIds: [String]
    let subnetIds: [String]
    let subnetIdsUsingRef: [SubnetIdsUsingRef]?

    private enum CodingKeys: String, CodingKey {
        case securityGroupIds = "SecurityGroupIds"
        case subnetIds = "SubnetIds"
        case subnetIdsUsingRef = "SubnetIdsUsingRef"
    }
}

public struct ServerlessFunctionS3NotificationFilter: Codable, Sendable {
    public struct S3KeyObject: Codable, Sendable {
    }
    let s3Key: [String: S3Key]

    public enum S3Key: Codable, Sendable {
        case itemString(String)
        case itemObject(S3KeyObject)
    }

    private enum CodingKeys: String, CodingKey {
        case s3Key = "S3Key"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {
    let region: String?
    let topic: String

    public struct FilterPolicy: Codable, Sendable {
    }
    let filterPolicy: FilterPolicy?
    let filterPolicyScope: String?

    private enum CodingKeys: String, CodingKey {
        case region = "Region"
        case topic = "Topic"
        case filterPolicy = "FilterPolicy"
        case filterPolicyScope = "FilterPolicyScope"
    }
}

public struct ServerlessFunctionS3Location: Codable, Sendable {
    let bucket: String
    let version: Double?
    let key: String

    private enum CodingKeys: String, CodingKey {
        case bucket = "Bucket"
        case version = "Version"
        case key = "Key"
    }
}

public struct Parameter: Codable, Sendable {
    let maxLength: String?
    let minValue: String?
    let description: String?
    let allowedPattern: String?

    public enum `Type`: String, Codable, Sendable {
        case string_ = "String"
        case number_ = "Number"
        case listNumber_ = "List<Number>"
        case commaDelimitedList_ = "CommaDelimitedList"
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
        case listString_ = "List<String>"
    }
    let type: `Type` = .string_
    let allowedValues: [String]?
    let noEcho: not supported yet ⚠️?
    let constraintDescription: String?
    let `default`: String?
    let maxValue: String?
    let minLength: String?

    private enum CodingKeys: String, CodingKey {
        case maxLength = "MaxLength"
        case minValue = "MinValue"
        case description = "Description"
        case allowedPattern = "AllowedPattern"
        case type = "Type"
        case allowedValues = "AllowedValues"
        case noEcho = "NoEcho"
        case constraintDescription = "ConstraintDescription"
        case `default` = "Default"
        case maxValue = "MaxValue"
        case minLength = "MinLength"
    }
}

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    public struct RestApiIdObject: Codable, Sendable {
    }
    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case itemString(String)
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

public struct Tag: Codable, Sendable {
    public struct ValueObject: Codable, Sendable {
    }
    let value: [String: Value]?

    public enum Value: Codable, Sendable {
        case itemString(String)
        case itemObject(ValueObject)
    }
    let key: String?

    private enum CodingKeys: String, CodingKey {
        case value = "Value"
        case key = "Key"
    }
}

public struct ServerlessFunctionDeadLetterQueue: Codable, Sendable {
    let type: String
    let targetArn: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case targetArn = "TargetArn"
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

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
    }
}

public struct ServerlessFunction: Codable, Sendable {

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    let updateReplacePolicy: String?
    let deletionPolicy: String?
    let condition: String?
    let properties: [String: Properties]
    public struct Properties: Codable, Sendable {
        let inlineCode: String?
        let codeUri: [String: CodeUri]?

        public enum CodeUri: Codable, Sendable {
            case itemString(String)
            case serverlessFunctionS3Location(ServerlessFunctionS3Location)
        }
        public struct RoleObject: Codable, Sendable {
        }
        let role: [String: Role]?

        public enum Role: Codable, Sendable {
            case itemString(String)
            case itemObject(RoleObject)
        }
        let functionName: String?
        let deadLetterQueue: ServerlessFunctionDeadLetterQueue?
        let tags: [String: String]?
        let timeout: Double?
        let tracing: String?
        let policies: [String: Policies]?

        public enum Policies: Codable, Sendable {
            case itemString(String)
            case items([String])
            case serverlessFunctionIAMPolicyDocument(ServerlessFunctionIAMPolicyDocument)
            case serverlessFunctionIAMPolicyDocumentItems([ServerlessFunctionIAMPolicyDocument])
        }
        let environment: ServerlessFunctionFunctionEnvironment?
        let memorySize: Double?
        let description: String?
        let kmsKeyArn: String?
        let vpcConfig: ServerlessFunctionVpcConfig?
        let runtime: String
        let events: [String: Events]?

        public enum Events: Codable, Sendable {
            case serverlessFunctionEventSource(ServerlessFunctionEventSource)
        }
        let handler: String

        private enum CodingKeys: String, CodingKey {
            case inlineCode = "InlineCode"
            case codeUri = "CodeUri"
            case role = "Role"
            case functionName = "FunctionName"
            case deadLetterQueue = "DeadLetterQueue"
            case tags = "Tags"
            case timeout = "Timeout"
            case tracing = "Tracing"
            case policies = "Policies"
            case environment = "Environment"
            case memorySize = "MemorySize"
            case description = "Description"
            case kmsKeyArn = "KmsKeyArn"
            case vpcConfig = "VpcConfig"
            case runtime = "Runtime"
            case events = "Events"
            case handler = "Handler"
        }
    }

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case dependsOn = "DependsOn"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case deletionPolicy = "DeletionPolicy"
        case condition = "Condition"
        case properties = "Properties"
        case metadata = "Metadata"
    }
}

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    let enabled: Bool?
    let batchSize: Double?
    public struct QueueObject: Codable, Sendable {
    }
    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case itemString(String)
        case itemObject(QueueObject)
    }

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case batchSize = "BatchSize"
        case queue = "Queue"
    }
}

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let enabled: Bool?
    let startingPosition: String
    let batchSize: Double?
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case startingPosition = "StartingPosition"
        case batchSize = "BatchSize"
        case stream = "Stream"
    }
}

public struct ServerlessFunctionIoTRuleEvent: Codable, Sendable {
    let awsIotSqlVersion: String?
    let sql: String

    private enum CodingKeys: String, CodingKey {
        case awsIotSqlVersion = "AwsIotSqlVersion"
        case sql = "Sql"
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
    let startingPosition: String
    let topics: [String]
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case startingPosition = "StartingPosition"
        case topics = "Topics"
        case stream = "Stream"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let input: String?
    let schedule: String
    let enabled: Bool?
    let name: String?
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case schedule = "Schedule"
        case enabled = "Enabled"
        case name = "Name"
        case description = "Description"
    }
}