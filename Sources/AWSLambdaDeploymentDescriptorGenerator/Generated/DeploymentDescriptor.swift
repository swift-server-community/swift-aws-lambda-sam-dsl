
public struct SAMDeploymentDescriptor: Codable, Sendable {
    let mappings: [String: Mappings]?

    public struct Mappings: Codable, Sendable {
    }
    let parameters: [String: Parameter]?
    let conditions: [String: Conditions]?

    public struct Conditions: Codable, Sendable {
    }
    let description: String?
    let transform: Transform? = .aws_Serverless_2016_10_31
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }
    let outputs: [String: Outputs]?

    public struct Outputs: Codable, Sendable {
    }

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    private enum CodingKeys: String, CodingKey {
        case mappings = "Mappings"
        case parameters = "Parameters"
        case conditions = "Conditions"
        case description = "Description"
        case transform = "Transform"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case resources = "Resources"
        case outputs = "Outputs"
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

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
    }
}

public struct ServerlessFunction: Codable, Sendable {
    let properties: [String: Properties]
    public struct Properties: Codable, Sendable {
        let inlineCode: String?
        let codeUri: [String: CodeUri]?

        public enum CodeUri: Codable, Sendable {
            case itemString(String)
            case serverlessFunctionS3Location(ServerlessFunctionS3Location)
        }
        let policies: [String: Policies]?

        public enum Policies: Codable, Sendable {
            case itemString(String)
            case items([String])
            case serverlessFunctionIAMPolicyDocument(ServerlessFunctionIAMPolicyDocument)
            case serverlessFunctionIAMPolicyDocumentItems([ServerlessFunctionIAMPolicyDocument])
        }
        let tags: [String: String]?
        public struct RoleObject: Codable, Sendable {
        }
        let role: [String: Role]?

        public enum Role: Codable, Sendable {
            case itemString(String)
            case itemObject(RoleObject)
        }
        let memorySize: Double?
        let tracing: String?
        let events: [String: Events]?

        public enum Events: Codable, Sendable {
            case serverlessFunctionEventSource(ServerlessFunctionEventSource)
        }
        let handler: String
        let kmsKeyArn: String?
        let functionName: String?
        let deadLetterQueue: ServerlessFunctionDeadLetterQueue?
        let environment: ServerlessFunctionFunctionEnvironment?
        let vpcConfig: ServerlessFunctionVpcConfig?
        let timeout: Double?
        let description: String?
        let runtime: String

        private enum CodingKeys: String, CodingKey {
            case inlineCode = "InlineCode"
            case codeUri = "CodeUri"
            case policies = "Policies"
            case tags = "Tags"
            case role = "Role"
            case memorySize = "MemorySize"
            case tracing = "Tracing"
            case events = "Events"
            case handler = "Handler"
            case kmsKeyArn = "KmsKeyArn"
            case functionName = "FunctionName"
            case deadLetterQueue = "DeadLetterQueue"
            case environment = "Environment"
            case vpcConfig = "VpcConfig"
            case timeout = "Timeout"
            case description = "Description"
            case runtime = "Runtime"
        }
    }
    let condition: String?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function
    let updateReplacePolicy: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    let deletionPolicy: String?

    private enum CodingKeys: String, CodingKey {
        case properties = "Properties"
        case condition = "Condition"
        case metadata = "Metadata"
        case type = "Type"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case dependsOn = "DependsOn"
        case deletionPolicy = "DeletionPolicy"
    }
}

public struct ServerlessFunctionEventSource: Codable, Sendable {
    let type: String
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

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case properties = "Properties"
    }
}

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: [String: String]

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessFunctionS3Location: Codable, Sendable {
    let version: Double?
    let key: String
    let bucket: String

    private enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case bucket = "Bucket"
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

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct ServerlessFunctionVpcConfig: Codable, Sendable {

    public struct SubnetIdsUsingRef: Codable, Sendable {
    }
    let subnetIdsUsingRef: [SubnetIdsUsingRef]?
    let subnetIds: [String]
    let securityGroupIds: [String]

    private enum CodingKeys: String, CodingKey {
        case subnetIdsUsingRef = "SubnetIdsUsingRef"
        case subnetIds = "SubnetIds"
        case securityGroupIds = "SecurityGroupIds"
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

public struct ServerlessSimpleTableProvisionedThroughput: Codable, Sendable {
    let writeCapacityUnits: Double
    let readCapacityUnits: Double?

    private enum CodingKeys: String, CodingKey {
        case writeCapacityUnits = "WriteCapacityUnits"
        case readCapacityUnits = "ReadCapacityUnits"
    }
}

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    let method: String
    public struct RestApiIdObject: Codable, Sendable {
    }
    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case itemString(String)
        case itemObject(RestApiIdObject)
    }
    let path: String

    private enum CodingKeys: String, CodingKey {
        case method = "Method"
        case restApiId = "RestApiId"
        case path = "Path"
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

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let input: String?
    let name: String?
    let enabled: Bool?
    let schedule: String
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case name = "Name"
        case enabled = "Enabled"
        case schedule = "Schedule"
        case description = "Description"
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

public struct Tag: Codable, Sendable {
    let key: String?
    public struct ValueObject: Codable, Sendable {
    }
    let value: [String: Value]?

    public enum Value: Codable, Sendable {
        case itemString(String)
        case itemObject(ValueObject)
    }

    private enum CodingKeys: String, CodingKey {
        case key = "Key"
        case value = "Value"
    }
}

public struct ServerlessSimpleTable: Codable, Sendable {
    let condition: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let deletionPolicy: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
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
    let updateReplacePolicy: String?

    private enum CodingKeys: String, CodingKey {
        case condition = "Condition"
        case type = "Type"
        case metadata = "Metadata"
        case deletionPolicy = "DeletionPolicy"
        case dependsOn = "DependsOn"
        case properties = "Properties"
        case updateReplacePolicy = "UpdateReplacePolicy"
    }
}

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let startingPosition: String
    let stream: String
    let enabled: Bool?
    let batchSize: Double?

    private enum CodingKeys: String, CodingKey {
        case startingPosition = "StartingPosition"
        case stream = "Stream"
        case enabled = "Enabled"
        case batchSize = "BatchSize"
    }
}

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
}

public struct ServerlessFunctionMSKEvent: Codable, Sendable {
    let startingPosition: String
    let stream: String
    let topics: [String]

    private enum CodingKeys: String, CodingKey {
        case startingPosition = "StartingPosition"
        case stream = "Stream"
        case topics = "Topics"
    }
}

public struct ServerlessFunctionS3Event: Codable, Sendable {
    let filter: ServerlessFunctionS3NotificationFilter?
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

    private enum CodingKeys: String, CodingKey {
        case filter = "Filter"
        case bucket = "Bucket"
        case events = "Events"
    }
}

public struct Parameter: Codable, Sendable {

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
    let `default`: String?
    let maxValue: String?
    let allowedValues: [String]?
    let minLength: String?
    let description: String?
    let minValue: String?
    let maxLength: String?
    let noEcho: NoEcho?

    public enum NoEcho: Codable, Sendable {
        case string(String)
        case boolean(Bool)
    }
    let constraintDescription: String?
    let allowedPattern: String?

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case `default` = "Default"
        case maxValue = "MaxValue"
        case allowedValues = "AllowedValues"
        case minLength = "MinLength"
        case description = "Description"
        case minValue = "MinValue"
        case maxLength = "MaxLength"
        case noEcho = "NoEcho"
        case constraintDescription = "ConstraintDescription"
        case allowedPattern = "AllowedPattern"
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

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {

    public struct Statement: Codable, Sendable {
    }
    let statement: [Statement]

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
    }
}

public struct ServerlessApi: Codable, Sendable {
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    let updateReplacePolicy: String?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api
    let deletionPolicy: String?
    let condition: String?

    public struct Properties: Codable, Sendable {
        let description: String?

        public struct DefinitionBody: Codable, Sendable {
        }
        let definitionBody: DefinitionBody?
        public struct StageNameObject: Codable, Sendable {
        }
        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case itemString(String)
            case itemObject(StageNameObject)
        }
        public struct VariablesObject: Codable, Sendable {
        }
        let variables: [String: Variables]?

        public enum Variables: Codable, Sendable {
            case itemString(String)
            case itemObject(VariablesObject)
        }
        let name: String?
        let cacheClusterSize: String?
        let cacheClusterEnabled: Bool?
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case itemString(String)
            case serverlessApiS3Location(ServerlessApiS3Location)
        }
        let tracingEnabled: Bool?

        private enum CodingKeys: String, CodingKey {
            case description = "Description"
            case definitionBody = "DefinitionBody"
            case stageName = "StageName"
            case variables = "Variables"
            case name = "Name"
            case cacheClusterSize = "CacheClusterSize"
            case cacheClusterEnabled = "CacheClusterEnabled"
            case definitionUri = "DefinitionUri"
            case tracingEnabled = "TracingEnabled"
        }
    }
    let properties: Properties

    private enum CodingKeys: String, CodingKey {
        case dependsOn = "DependsOn"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case metadata = "Metadata"
        case type = "Type"
        case deletionPolicy = "DeletionPolicy"
        case condition = "Condition"
        case properties = "Properties"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {

    public struct RetryPolicy: Codable, Sendable {
        let maximumRetryAttempts: Double?
        let maximumEventAgeInSeconds: Double?

        private enum CodingKeys: String, CodingKey {
            case maximumRetryAttempts = "MaximumRetryAttempts"
            case maximumEventAgeInSeconds = "MaximumEventAgeInSeconds"
        }
    }
    let retryPolicy: RetryPolicy?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let ruleName: String?
    let input: String?

    public struct DeadLetterConfig: Codable, Sendable {
        let arn: String?
        let type: String?
        let queueLogicalId: String?

        private enum CodingKeys: String, CodingKey {
            case arn = "Arn"
            case type = "Type"
            case queueLogicalId = "QueueLogicalId"
        }
    }
    let deadLetterConfig: DeadLetterConfig?
    let inputPath: String?
    let state: String?

    private enum CodingKeys: String, CodingKey {
        case retryPolicy = "RetryPolicy"
        case pattern = "Pattern"
        case ruleName = "RuleName"
        case input = "Input"
        case deadLetterConfig = "DeadLetterConfig"
        case inputPath = "InputPath"
        case state = "State"
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

public struct ServerlessSimpleTablePrimaryKey: Codable, Sendable {
    let name: String?
    let type: String

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
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

public struct ServerlessFunctionLogEvent: Codable, Sendable {
    let filterPattern: String
    let logGroupName: String

    private enum CodingKeys: String, CodingKey {
        case filterPattern = "FilterPattern"
        case logGroupName = "LogGroupName"
    }
}