
public struct SAMDeploymentDescriptor: Codable, Sendable {
    let outputs: [String: Outputs]?

    public struct Outputs: Codable, Sendable {
    }
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }
    let transform: Transform? = .aws_Serverless_2016_10_31
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09
    let description: String?
    let parameters: [String: Parameter]?
    let conditions: [String: Conditions]?

    public struct Conditions: Codable, Sendable {
    }
    let mappings: [String: Mappings]?

    public struct Mappings: Codable, Sendable {
    }

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    private enum CodingKeys: String, CodingKey {
        case outputs = "Outputs"
        case resources = "Resources"
        case transform = "Transform"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case description = "Description"
        case parameters = "Parameters"
        case conditions = "Conditions"
        case mappings = "Mappings"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let eventBusName: String?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let inputPath: String?
    let input: String?

    private enum CodingKeys: String, CodingKey {
        case eventBusName = "EventBusName"
        case pattern = "Pattern"
        case inputPath = "InputPath"
        case input = "Input"
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

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {
    let statement: [Statement]

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let input: String?
    let enabled: Bool?
    let description: String?
    let name: String?
    let schedule: String

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case enabled = "Enabled"
        case description = "Description"
        case name = "Name"
        case schedule = "Schedule"
    }
}

public struct ServerlessApiS3Location: Codable, Sendable {
    let bucket: String
    let key: String
    let version: Double?

    private enum CodingKeys: String, CodingKey {
        case bucket = "Bucket"
        case key = "Key"
        case version = "Version"
    }
}

public struct Parameter: Codable, Sendable {
    let allowedValues: [Any]?
    let allowedPattern: String?
    let maxLength: String?
    let minLength: String?
    let description: String?
    let `default`: String?
    let constraintDescription: String?
    let noEcho: not supported yet ⚠️?
    let minValue: String?

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

    private enum CodingKeys: String, CodingKey {
        case allowedValues = "AllowedValues"
        case allowedPattern = "AllowedPattern"
        case maxLength = "MaxLength"
        case minLength = "MinLength"
        case description = "Description"
        case `default` = "Default"
        case constraintDescription = "ConstraintDescription"
        case noEcho = "NoEcho"
        case minValue = "MinValue"
        case type = "Type"
        case maxValue = "MaxValue"
    }
}

public struct ServerlessFunctionMQEvent: Codable, Sendable {
    let queues: [Any]
    let broker: String
    let sourceAccessConfigurations: [Any]

    private enum CodingKeys: String, CodingKey {
        case queues = "Queues"
        case broker = "Broker"
        case sourceAccessConfigurations = "SourceAccessConfigurations"
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

public struct ServerlessFunctionSNSEvent: Codable, Sendable {
    let topic: String
    let filterPolicyScope: String?

    public struct FilterPolicy: Codable, Sendable {
    }
    let filterPolicy: FilterPolicy?
    let region: String?

    private enum CodingKeys: String, CodingKey {
        case topic = "Topic"
        case filterPolicyScope = "FilterPolicyScope"
        case filterPolicy = "FilterPolicy"
        case region = "Region"
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

public struct ServerlessSimpleTablePrimaryKey: Codable, Sendable {
    let name: String?
    let type: String

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
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

public struct ServerlessApi: Codable, Sendable {
    let condition: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api

    public struct Properties: Codable, Sendable {
        let description: String?
        public struct VariablesObject: Codable, Sendable {
        }
        let variables: [String: Variables]?

        public enum Variables: Codable, Sendable {
            case itemString(String)
            case itemObject(VariablesObject)
        }
        let cacheClusterEnabled: Bool?
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case itemString(String)
            case serverlessApiS3Location(ServerlessApiS3Location?)
        }
        let cacheClusterSize: String?
        let tracingEnabled: Bool?
        let name: String?

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

        private enum CodingKeys: String, CodingKey {
            case description = "Description"
            case variables = "Variables"
            case cacheClusterEnabled = "CacheClusterEnabled"
            case definitionUri = "DefinitionUri"
            case cacheClusterSize = "CacheClusterSize"
            case tracingEnabled = "TracingEnabled"
            case name = "Name"
            case definitionBody = "DefinitionBody"
            case stageName = "StageName"
        }
    }
    let properties: Properties

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let deletionPolicy: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    let updateReplacePolicy: String?

    private enum CodingKeys: String, CodingKey {
        case condition = "Condition"
        case type = "Type"
        case properties = "Properties"
        case metadata = "Metadata"
        case deletionPolicy = "DeletionPolicy"
        case dependsOn = "DependsOn"
        case updateReplacePolicy = "UpdateReplacePolicy"
    }
}

public struct ServerlessFunctionMSKEvent: Codable, Sendable {
    let stream: String
    let startingPosition: String
    let topics: [Any]

    private enum CodingKeys: String, CodingKey {
        case stream = "Stream"
        case startingPosition = "StartingPosition"
        case topics = "Topics"
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

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern

    public struct RetryPolicy: Codable, Sendable {
        let maximumRetryAttempts: Double?
        let maximumEventAgeInSeconds: Double?

        private enum CodingKeys: String, CodingKey {
            case maximumRetryAttempts = "MaximumRetryAttempts"
            case maximumEventAgeInSeconds = "MaximumEventAgeInSeconds"
        }
    }
    let retryPolicy: RetryPolicy?

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
    let input: String?
    let state: String?
    let ruleName: String?
    let inputPath: String?

    private enum CodingKeys: String, CodingKey {
        case pattern = "Pattern"
        case retryPolicy = "RetryPolicy"
        case deadLetterConfig = "DeadLetterConfig"
        case input = "Input"
        case state = "State"
        case ruleName = "RuleName"
        case inputPath = "InputPath"
    }
}

public struct ServerlessFunction: Codable, Sendable {
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    let condition: String?
    let deletionPolicy: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let updateReplacePolicy: String?

    private enum CodingKeys: String, CodingKey {
        case dependsOn = "DependsOn"
        case condition = "Condition"
        case deletionPolicy = "DeletionPolicy"
        case type = "Type"
        case metadata = "Metadata"
        case updateReplacePolicy = "UpdateReplacePolicy"
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

public struct ServerlessFunctionVpcConfig: Codable, Sendable {
    let subnetIds: [String]
    let securityGroupIds: [String]
    let subnetIdsUsingRef: [SubnetIdsUsingRef]?

    private enum CodingKeys: String, CodingKey {
        case subnetIds = "SubnetIds"
        case securityGroupIds = "SecurityGroupIds"
        case subnetIdsUsingRef = "SubnetIdsUsingRef"
    }
}

public struct ServerlessSimpleTable: Codable, Sendable {

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    let deletionPolicy: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable
    let updateReplacePolicy: String?
    let condition: String?

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

    private enum CodingKeys: String, CodingKey {
        case metadata = "Metadata"
        case dependsOn = "DependsOn"
        case deletionPolicy = "DeletionPolicy"
        case type = "Type"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case condition = "Condition"
        case properties = "Properties"
    }
}

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    public struct QueueObject: Codable, Sendable {
    }
    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case itemString(String)
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

public struct ServerlessSimpleTableProvisionedThroughput: Codable, Sendable {
    let readCapacityUnits: Double?
    let writeCapacityUnits: Double

    private enum CodingKeys: String, CodingKey {
        case readCapacityUnits = "ReadCapacityUnits"
        case writeCapacityUnits = "WriteCapacityUnits"
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

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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