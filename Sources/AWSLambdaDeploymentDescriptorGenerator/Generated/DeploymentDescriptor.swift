
public struct SAMDeploymentDescriptor: Codable, Sendable {
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

    public struct Globals: Codable, Sendable {
    }
    let globals: Globals?

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }
    let transform: Transform? = .aws_Serverless_2016_10_31
    let description: String?

    public struct Properties: Codable, Sendable {
    }
    let properties: Properties?

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09

    public struct Outputs: Codable, Sendable {
    }
    let outputs: [String: Outputs]?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    public struct Mappings: Codable, Sendable {
    }
    let mappings: [String: Mappings]?
    let parameters: [String: Parameter]?

    private enum CodingKeys: String, CodingKey {
        case resources = "Resources"
        case conditions = "Conditions"
        case globals = "Globals"
        case transform = "Transform"
        case description = "Description"
        case properties = "Properties"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case outputs = "Outputs"
        case metadata = "Metadata"
        case mappings = "Mappings"
        case parameters = "Parameters"
    }
}

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
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

public struct ServerlessFunction: Codable, Sendable {
    let deletionPolicy: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let condition: String?
    let updateReplacePolicy: String?
    let properties: [String: Properties]
    public struct Properties: Codable, Sendable {
        let inlineCode: String?
        let codeUri: [String: CodeUri]?

        public enum CodeUri: Codable, Sendable {
            case item(String)
            case serverlessFunctionS3Location(ServerlessFunctionS3Location)
        }
        let kmsKeyArn: String?
        let handler: String
        let environment: ServerlessFunctionFunctionEnvironment?
        let deadLetterQueue: ServerlessFunctionDeadLetterQueue?
        let description: String?
        public struct RoleObject: Codable, Sendable {
        }
        let role: [String: Role]?

        public enum Role: Codable, Sendable {
            case item(String)
            case itemObject(RoleObject)
        }
        let functionName: String?
        let tracing: String?
        let runtime: String
        let policies: [String: Policies]?

        public enum Policies: Codable, Sendable {
            case item(String)
            case itemArray([String])
            case serverlessFunctionIAMPolicyDocument(ServerlessFunctionIAMPolicyDocument)
            case serverlessFunctionIAMPolicyDocumentArray([ServerlessFunctionIAMPolicyDocument])
        }
        let tags: [String: String]?
        let events: [String: ServerlessFunctionEventSource]?
        let memorySize: Double?
        let timeout: Double?
        let vpcConfig: ServerlessFunctionVpcConfig?

        private enum CodingKeys: String, CodingKey {
            case inlineCode = "InlineCode"
            case codeUri = "CodeUri"
            case kmsKeyArn = "KmsKeyArn"
            case handler = "Handler"
            case environment = "Environment"
            case deadLetterQueue = "DeadLetterQueue"
            case description = "Description"
            case role = "Role"
            case functionName = "FunctionName"
            case tracing = "Tracing"
            case runtime = "Runtime"
            case policies = "Policies"
            case tags = "Tags"
            case events = "Events"
            case memorySize = "MemorySize"
            case timeout = "Timeout"
            case vpcConfig = "VpcConfig"
        }
    }
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    private enum CodingKeys: String, CodingKey {
        case deletionPolicy = "DeletionPolicy"
        case type = "Type"
        case metadata = "Metadata"
        case condition = "Condition"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case properties = "Properties"
        case dependsOn = "DependsOn"
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

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    public struct QueueObject: Codable, Sendable {
    }
    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case item(String)
        case itemObject(QueueObject)
    }
    let batchSize: Double?
    let enabled: Bool?

    private enum CodingKeys: String, CodingKey {
        case queue = "Queue"
        case batchSize = "BatchSize"
        case enabled = "Enabled"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
    let inputPath: String?
    let input: String?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
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
    let ruleName: String?

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
        case inputPath = "InputPath"
        case input = "Input"
        case pattern = "Pattern"
        case state = "State"
        case deadLetterConfig = "DeadLetterConfig"
        case ruleName = "RuleName"
        case retryPolicy = "RetryPolicy"
    }
}

public struct ServerlessApi: Codable, Sendable {

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let condition: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }
    let updateReplacePolicy: String?
    let deletionPolicy: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api

    public struct Properties: Codable, Sendable {
        public struct VariablesObject: Codable, Sendable {
        }
        let variables: [String: Variables]?

        public enum Variables: Codable, Sendable {
            case item(String)
            case itemObject(VariablesObject)
        }
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case item(String)
            case serverlessApiS3Location(ServerlessApiS3Location)
        }
        let description: String?
        public struct StageNameObject: Codable, Sendable {
        }
        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case item(String)
            case itemObject(StageNameObject)
        }
        let name: String?
        let cacheClusterSize: String?
        let cacheClusterEnabled: Bool?
        let tracingEnabled: Bool?

        public struct DefinitionBody: Codable, Sendable {
        }
        let definitionBody: DefinitionBody?

        private enum CodingKeys: String, CodingKey {
            case variables = "Variables"
            case definitionUri = "DefinitionUri"
            case description = "Description"
            case stageName = "StageName"
            case name = "Name"
            case cacheClusterSize = "CacheClusterSize"
            case cacheClusterEnabled = "CacheClusterEnabled"
            case tracingEnabled = "TracingEnabled"
            case definitionBody = "DefinitionBody"
        }
    }
    let properties: Properties

    private enum CodingKeys: String, CodingKey {
        case metadata = "Metadata"
        case condition = "Condition"
        case dependsOn = "DependsOn"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case deletionPolicy = "DeletionPolicy"
        case type = "Type"
        case properties = "Properties"
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

public struct ServerlessSimpleTable: Codable, Sendable {
    let condition: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    public struct Properties: Codable, Sendable {
        let provisionedThroughput: ServerlessSimpleTableProvisionedThroughput?
        let primaryKey: ServerlessSimpleTablePrimaryKey?
        let sseSpecification: ServerlessSimpleTableSSESpecification?

        private enum CodingKeys: String, CodingKey {
            case provisionedThroughput = "ProvisionedThroughput"
            case primaryKey = "PrimaryKey"
            case sseSpecification = "SSESpecification"
        }
    }
    let properties: Properties?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }
    let updateReplacePolicy: String?
    let deletionPolicy: String?

    private enum CodingKeys: String, CodingKey {
        case condition = "Condition"
        case type = "Type"
        case metadata = "Metadata"
        case properties = "Properties"
        case dependsOn = "DependsOn"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case deletionPolicy = "DeletionPolicy"
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

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
    }
}

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: [String: String]

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    let path: String
    public struct RestApiIdObject: Codable, Sendable {
    }
    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case item(String)
        case itemObject(RestApiIdObject)
    }
    let method: String

    private enum CodingKeys: String, CodingKey {
        case path = "Path"
        case restApiId = "RestApiId"
        case method = "Method"
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

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let inputPath: String?
    let input: String?
    let eventBusName: String?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern

    private enum CodingKeys: String, CodingKey {
        case inputPath = "InputPath"
        case input = "Input"
        case eventBusName = "EventBusName"
        case pattern = "Pattern"
    }
}

public struct Parameter: Codable, Sendable {
    let constraintDescription: String?
    let `default`: String?
    let maxLength: String?
    let allowedValues: [String]?
    let noEcho: NoEcho?

    public enum NoEcho: Codable, Sendable {
        case string(String)
        case boolean(Bool)
    }
    let description: String?
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
    let minValue: String?
    let maxValue: String?
    let minLength: String?

    private enum CodingKeys: String, CodingKey {
        case constraintDescription = "ConstraintDescription"
        case `default` = "Default"
        case maxLength = "MaxLength"
        case allowedValues = "AllowedValues"
        case noEcho = "NoEcho"
        case description = "Description"
        case allowedPattern = "AllowedPattern"
        case type = "Type"
        case minValue = "MinValue"
        case maxValue = "MaxValue"
        case minLength = "MinLength"
    }
}

public struct ServerlessFunctionVpcConfig: Codable, Sendable {
    let subnetIds: [String]

    public struct SubnetIdsUsingRef: Codable, Sendable {
    }
    let subnetIdsUsingRef: [SubnetIdsUsingRef]?
    let securityGroupIds: [String]

    private enum CodingKeys: String, CodingKey {
        case subnetIds = "SubnetIds"
        case subnetIdsUsingRef = "SubnetIdsUsingRef"
        case securityGroupIds = "SecurityGroupIds"
    }
}

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {

    public struct Statement: Codable, Sendable {
    }
    let statement: [Statement]

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
    }
}

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let batchSize: Double
    let startingPosition: String
    let enabled: Bool?
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case batchSize = "BatchSize"
        case startingPosition = "StartingPosition"
        case enabled = "Enabled"
        case stream = "Stream"
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

public struct ServerlessFunctionLogEvent: Codable, Sendable {
    let filterPattern: String
    let logGroupName: String

    private enum CodingKeys: String, CodingKey {
        case filterPattern = "FilterPattern"
        case logGroupName = "LogGroupName"
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

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let batchSize: Double?
    let enabled: Bool?
    let startingPosition: String
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case batchSize = "BatchSize"
        case enabled = "Enabled"
        case startingPosition = "StartingPosition"
        case stream = "Stream"
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