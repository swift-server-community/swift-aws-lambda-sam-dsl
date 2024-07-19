
public struct SAMDeploymentDescriptor: Codable, Sendable {
    let description: String?
    let parameters: [String: Parameter]?
    let mappings: [String: Mappings]?

    public struct Mappings: Codable, Sendable {
    }
    let outputs: [String: Outputs]?

    public struct Outputs: Codable, Sendable {
    }
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09
    let transform: Transform? = .aws_Serverless_2016_10_31
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }
    let conditions: [String: Conditions]?

    public struct Conditions: Codable, Sendable {
    }

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    private enum CodingKeys: String, CodingKey {
        case description = "Description"
        case parameters = "Parameters"
        case mappings = "Mappings"
        case outputs = "Outputs"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case transform = "Transform"
        case resources = "Resources"
        case conditions = "Conditions"
    }
}

public struct ServerlessApi: Codable, Sendable {

    public struct Properties: Codable, Sendable {
        public struct VariablesObject: Codable, Sendable {
        }
        let variables: [String: Variables]?

        public enum Variables: Codable, Sendable {
            case itemString(String)
            case itemObject(VariablesObject)
        }

        public struct DefinitionBody: Codable, Sendable {
        }
        let definitionBody: DefinitionBody?
        let cacheClusterSize: String?
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case itemString(String)
            case serverlessApiS3Location(ServerlessApiS3Location)
        }
        let tracingEnabled: Bool?
        let name: String?
        public struct StageNameObject: Codable, Sendable {
        }
        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case itemString(String)
            case itemObject(StageNameObject)
        }
        let cacheClusterEnabled: Bool?
        let description: String?

        private enum CodingKeys: String, CodingKey {
            case variables = "Variables"
            case definitionBody = "DefinitionBody"
            case cacheClusterSize = "CacheClusterSize"
            case definitionUri = "DefinitionUri"
            case tracingEnabled = "TracingEnabled"
            case name = "Name"
            case stageName = "StageName"
            case cacheClusterEnabled = "CacheClusterEnabled"
            case description = "Description"
        }
    }
    let properties: Properties
    let deletionPolicy: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api
    let condition: String?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let updateReplacePolicy: String?

    private enum CodingKeys: String, CodingKey {
        case properties = "Properties"
        case deletionPolicy = "DeletionPolicy"
        case dependsOn = "DependsOn"
        case type = "Type"
        case condition = "Condition"
        case metadata = "Metadata"
        case updateReplacePolicy = "UpdateReplacePolicy"
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

public struct ServerlessSimpleTablePrimaryKey: Codable, Sendable {
    let name: String?
    let type: String

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
    }
}

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {
    let filterPolicyScope: String?
    let topic: String
    let region: String?

    public struct FilterPolicy: Codable, Sendable {
    }
    let filterPolicy: FilterPolicy?

    private enum CodingKeys: String, CodingKey {
        case filterPolicyScope = "FilterPolicyScope"
        case topic = "Topic"
        case region = "Region"
        case filterPolicy = "FilterPolicy"
    }
}

public struct ServerlessApiS3Location: Codable, Sendable {
    let bucket: String
    let version: Double?
    let key: String

    private enum CodingKeys: String, CodingKey {
        case bucket = "Bucket"
        case version = "Version"
        case key = "Key"
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

public struct ServerlessSimpleTable: Codable, Sendable {

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
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let deletionPolicy: String?
    let condition: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable

    private enum CodingKeys: String, CodingKey {
        case properties = "Properties"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case dependsOn = "DependsOn"
        case metadata = "Metadata"
        case deletionPolicy = "DeletionPolicy"
        case condition = "Condition"
        case type = "Type"
    }
}

public struct ServerlessFunctionVpcConfig: Codable, Sendable {
    let subnetIds: [String]
    let subnetIdsUsingRef: [SubnetIdsUsingRef]?
    let securityGroupIds: [String]

    private enum CodingKeys: String, CodingKey {
        case subnetIds = "SubnetIds"
        case subnetIdsUsingRef = "SubnetIdsUsingRef"
        case securityGroupIds = "SecurityGroupIds"
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

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let eventBusName: String?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let input: String?
    let inputPath: String?

    private enum CodingKeys: String, CodingKey {
        case eventBusName = "EventBusName"
        case pattern = "Pattern"
        case input = "Input"
        case inputPath = "InputPath"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
    let inputPath: String?
    let ruleName: String?

    public struct DeadLetterConfig: Codable, Sendable {
        let type: String?
        let arn: String?
        let queueLogicalId: String?

        private enum CodingKeys: String, CodingKey {
            case type = "Type"
            case arn = "Arn"
            case queueLogicalId = "QueueLogicalId"
        }
    }
    let deadLetterConfig: DeadLetterConfig?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let state: String?

    public struct RetryPolicy: Codable, Sendable {
        let maximumEventAgeInSeconds: Double?
        let maximumRetryAttempts: Double?

        private enum CodingKeys: String, CodingKey {
            case maximumEventAgeInSeconds = "MaximumEventAgeInSeconds"
            case maximumRetryAttempts = "MaximumRetryAttempts"
        }
    }
    let retryPolicy: RetryPolicy?
    let input: String?

    private enum CodingKeys: String, CodingKey {
        case inputPath = "InputPath"
        case ruleName = "RuleName"
        case deadLetterConfig = "DeadLetterConfig"
        case pattern = "Pattern"
        case state = "State"
        case retryPolicy = "RetryPolicy"
        case input = "Input"
    }
}

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    let method: String
    let path: String
    public struct RestApiIdObject: Codable, Sendable {
    }
    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case itemString(String)
        case itemObject(RestApiIdObject)
    }

    private enum CodingKeys: String, CodingKey {
        case method = "Method"
        case path = "Path"
        case restApiId = "RestApiId"
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

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {
    let statement: [Statement]

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
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
    let maxValue: String?
    let description: String?
    let allowedValues: [String]?
    let maxLength: String?
    let minLength: String?
    let constraintDescription: String?
    let noEcho: not supported yet ⚠️?
    let allowedPattern: String?
    let minValue: String?
    let `default`: String?

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case maxValue = "MaxValue"
        case description = "Description"
        case allowedValues = "AllowedValues"
        case maxLength = "MaxLength"
        case minLength = "MinLength"
        case constraintDescription = "ConstraintDescription"
        case noEcho = "NoEcho"
        case allowedPattern = "AllowedPattern"
        case minValue = "MinValue"
        case `default` = "Default"
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

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: [String: String]

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let enabled: Bool?
    let batchSize: Double
    let startingPosition: String
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case batchSize = "BatchSize"
        case startingPosition = "StartingPosition"
        case stream = "Stream"
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

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let enabled: Bool?
    let stream: String
    let batchSize: Double?
    let startingPosition: String

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case stream = "Stream"
        case batchSize = "BatchSize"
        case startingPosition = "StartingPosition"
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

public struct ServerlessFunction: Codable, Sendable {
    let updateReplacePolicy: String?
    let condition: String?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    public struct Properties: Codable, Sendable {
        let description: String?
        let environment: ServerlessFunctionFunctionEnvironment?
        let tracing: String?
        let functionName: String?
        let runtime: String
        let deadLetterQueue: ServerlessFunctionDeadLetterQueue?
        let vpcConfig: ServerlessFunctionVpcConfig?
        let kmsKeyArn: String?
        let policies: [String: Policies]?

        public enum Policies: Codable, Sendable {
            case itemString(String)
            case items([String])
            case serverlessFunctionIAMPolicyDocument(ServerlessFunctionIAMPolicyDocument)
            case serverlessFunctionIAMPolicyDocumentItems([ServerlessFunctionIAMPolicyDocument])
        }
        public struct RoleObject: Codable, Sendable {
        }
        let role: [String: Role]?

        public enum Role: Codable, Sendable {
            case itemString(String)
            case itemObject(RoleObject)
        }
        let tags: [String: String]?
        let memorySize: Double?
        let timeout: Double?
        let events: [String: Events]?

        public enum Events: Codable, Sendable {
            case serverlessFunctionEventSource(ServerlessFunctionEventSource)
        }
        let handler: String

        private enum CodingKeys: String, CodingKey {
            case description = "Description"
            case environment = "Environment"
            case tracing = "Tracing"
            case functionName = "FunctionName"
            case runtime = "Runtime"
            case deadLetterQueue = "DeadLetterQueue"
            case vpcConfig = "VpcConfig"
            case kmsKeyArn = "KmsKeyArn"
            case policies = "Policies"
            case role = "Role"
            case tags = "Tags"
            case memorySize = "MemorySize"
            case timeout = "Timeout"
            case events = "Events"
            case handler = "Handler"
        }
    }
    let deletionPolicy: String?

    private enum CodingKeys: String, CodingKey {
        case updateReplacePolicy = "UpdateReplacePolicy"
        case condition = "Condition"
        case metadata = "Metadata"
        case type = "Type"
        case dependsOn = "DependsOn"
        case properties = "Properties"
        case deletionPolicy = "DeletionPolicy"
    }
}

public struct ServerlessFunctionCognitoEvent: Codable, Sendable {
    public struct UserPoolObject: Codable, Sendable {
    }
    let userPool: [String: UserPool]

    public enum UserPool: Codable, Sendable {
        case itemString(String)
        case itemObject(UserPoolObject)
    }
    let trigger: [String: Trigger]

    public enum Trigger: Codable, Sendable {
        case itemString(String)
        case items([String])
    }

    private enum CodingKeys: String, CodingKey {
        case userPool = "UserPool"
        case trigger = "Trigger"
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

public struct ServerlessFunctionS3Event: Codable, Sendable {
    let filter: ServerlessFunctionS3NotificationFilter?
    let events: [String: Events]

    public enum Events: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    public struct BucketObject: Codable, Sendable {
    }
    let bucket: [String: Bucket]

    public enum Bucket: Codable, Sendable {
        case itemString(String)
        case itemObject(BucketObject)
    }

    private enum CodingKeys: String, CodingKey {
        case filter = "Filter"
        case events = "Events"
        case bucket = "Bucket"
    }
}