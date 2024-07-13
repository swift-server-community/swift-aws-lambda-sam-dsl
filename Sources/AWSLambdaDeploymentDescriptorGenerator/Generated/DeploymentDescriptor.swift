
public struct SAMDeploymentDescriptor: Codable, Sendable {
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09
    let description: String?

    public struct Outputs: Codable, Sendable {
    }
    let outputs: Outputs?

    public struct Parameters: Codable, Sendable {
    }
    let parameters: Parameters?

    public struct Conditions: Codable, Sendable {
    }
    let conditions: Conditions?
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }
    let transform: Transform? = .aws_Serverless_2016_10_31

    public struct Mappings: Codable, Sendable {
    }
    let mappings: Mappings?

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    private enum CodingKeys: String, CodingKey {
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case description = "Description"
        case outputs = "Outputs"
        case parameters = "Parameters"
        case conditions = "Conditions"
        case resources = "Resources"
        case transform = "Transform"
        case mappings = "Mappings"
    }
}

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    public struct RestApiIdObject: Codable, Sendable {
    }
    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case itemsString(String)
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

public struct ServerlessSimpleTableProvisionedThroughput: Codable, Sendable {
    let readCapacityUnits: Double?
    let writeCapacityUnits: Double

    private enum CodingKeys: String, CodingKey {
        case readCapacityUnits = "ReadCapacityUnits"
        case writeCapacityUnits = "WriteCapacityUnits"
    }
}

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let batchSize: Double
    let enabled: Bool?
    let stream: String
    let startingPosition: String

    private enum CodingKeys: String, CodingKey {
        case batchSize = "BatchSize"
        case enabled = "Enabled"
        case stream = "Stream"
        case startingPosition = "StartingPosition"
    }
}

public struct ServerlessFunctionS3NotificationFilter: Codable, Sendable {
    public struct S3KeyObject: Codable, Sendable {
    }
    let s3Key: [String: S3Key]

    public enum S3Key: Codable, Sendable {
        case itemsString(String)
        case itemObject(S3KeyObject)
    }

    private enum CodingKeys: String, CodingKey {
        case s3Key = "S3Key"
    }
}

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {

    public struct Variables: Codable, Sendable {
    }
    let variables: Variables?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessApi: Codable, Sendable {
    let updateReplacePolicy: String?
    let deletionPolicy: String?
    let condition: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api

    public struct Properties: Codable, Sendable {
        let cacheClusterSize: String?
        public struct StageNameObject: Codable, Sendable {
        }
        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case itemsString(String)
            case itemObject(StageNameObject)
        }
        let description: String?

        public struct DefinitionBody: Codable, Sendable {
        }
        let definitionBody: DefinitionBody?
        let tracingEnabled: Bool?
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case itemsString(String)
            case serverlessApiS3Location(ServerlessApiS3Location?)
        }
        let cacheClusterEnabled: Bool?

        public struct Variables: Codable, Sendable {
        }
        let variables: Variables?
        let name: String?

        private enum CodingKeys: String, CodingKey {
            case cacheClusterSize = "CacheClusterSize"
            case stageName = "StageName"
            case description = "Description"
            case definitionBody = "DefinitionBody"
            case tracingEnabled = "TracingEnabled"
            case definitionUri = "DefinitionUri"
            case cacheClusterEnabled = "CacheClusterEnabled"
            case variables = "Variables"
            case name = "Name"
        }
    }
    let properties: Properties

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }

    private enum CodingKeys: String, CodingKey {
        case updateReplacePolicy = "UpdateReplacePolicy"
        case deletionPolicy = "DeletionPolicy"
        case condition = "Condition"
        case type = "Type"
        case properties = "Properties"
        case metadata = "Metadata"
        case dependsOn = "DependsOn"
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
        case itemsString(String)
        case itemObject(ValueObject)
    }
    let key: String?

    private enum CodingKeys: String, CodingKey {
        case value = "Value"
        case key = "Key"
    }
}

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let eventBusName: String?
    let inputPath: String?
    let input: String?

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern

    private enum CodingKeys: String, CodingKey {
        case eventBusName = "EventBusName"
        case inputPath = "InputPath"
        case input = "Input"
        case pattern = "Pattern"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {

    public struct FilterPolicy: Codable, Sendable {
    }
    let filterPolicy: FilterPolicy?
    let filterPolicyScope: String?
    let topic: String
    let region: String?

    private enum CodingKeys: String, CodingKey {
        case filterPolicy = "FilterPolicy"
        case filterPolicyScope = "FilterPolicyScope"
        case topic = "Topic"
        case region = "Region"
    }
}

public struct ServerlessFunctionMQEvent: Codable, Sendable {
    let broker: String
    let queues: [Any]
    let sourceAccessConfigurations: [Any]

    private enum CodingKeys: String, CodingKey {
        case broker = "Broker"
        case queues = "Queues"
        case sourceAccessConfigurations = "SourceAccessConfigurations"
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

public struct ServerlessApiS3Location: Codable, Sendable {
    let version: Double?
    let bucket: String
    let key: String

    private enum CodingKeys: String, CodingKey {
        case version = "Version"
        case bucket = "Bucket"
        case key = "Key"
    }
}

public struct ServerlessFunctionS3Event: Codable, Sendable {
    let events: [String: Events]

    public enum Events: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }
    let filter: ServerlessFunctionS3NotificationFilter?
    public struct BucketObject: Codable, Sendable {
    }
    let bucket: [String: Bucket]

    public enum Bucket: Codable, Sendable {
        case itemsString(String)
        case itemObject(BucketObject)
    }

    private enum CodingKeys: String, CodingKey {
        case events = "Events"
        case filter = "Filter"
        case bucket = "Bucket"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {

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

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let inputPath: String?
    let state: String?
    let ruleName: String?

    private enum CodingKeys: String, CodingKey {
        case deadLetterConfig = "DeadLetterConfig"
        case retryPolicy = "RetryPolicy"
        case input = "Input"
        case pattern = "Pattern"
        case inputPath = "InputPath"
        case state = "State"
        case ruleName = "RuleName"
    }
}

public struct Parameter: Codable, Sendable {
    let maxValue: String?
    let description: String?
    let minLength: String?
    let minValue: String?
    let allowedValues: [Any]?
    let constraintDescription: String?

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
    let allowedPattern: String?
    let noEcho: not supported yet ⚠️?
    let maxLength: String?
    let default: String?

    private enum CodingKeys: String, CodingKey {
        case maxValue = "MaxValue"
        case description = "Description"
        case minLength = "MinLength"
        case minValue = "MinValue"
        case allowedValues = "AllowedValues"
        case constraintDescription = "ConstraintDescription"
        case type = "Type"
        case allowedPattern = "AllowedPattern"
        case noEcho = "NoEcho"
        case maxLength = "MaxLength"
        case default = "Default"
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

public struct ServerlessFunctionMSKEvent: Codable, Sendable {
    let startingPosition: String
    let topics: [Any]
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case startingPosition = "StartingPosition"
        case topics = "Topics"
        case stream = "Stream"
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

public struct ServerlessSimpleTable: Codable, Sendable {
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

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable
    let updateReplacePolicy: String?
    let condition: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    private enum CodingKeys: String, CodingKey {
        case deletionPolicy = "DeletionPolicy"
        case properties = "Properties"
        case type = "Type"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case condition = "Condition"
        case dependsOn = "DependsOn"
        case metadata = "Metadata"
    }
}

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
    }
}

public struct ServerlessFunctionCognitoEvent: Codable, Sendable {
    let trigger: [String: Trigger]

    public enum Trigger: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }
    public struct UserPoolObject: Codable, Sendable {
    }
    let userPool: [String: UserPool]

    public enum UserPool: Codable, Sendable {
        case itemsString(String)
        case itemObject(UserPoolObject)
    }

    private enum CodingKeys: String, CodingKey {
        case trigger = "Trigger"
        case userPool = "UserPool"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let description: String?
    let name: String?
    let enabled: Bool?
    let schedule: String
    let input: String?

    private enum CodingKeys: String, CodingKey {
        case description = "Description"
        case name = "Name"
        case enabled = "Enabled"
        case schedule = "Schedule"
        case input = "Input"
    }
}

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {

    public struct Variables: Codable, Sendable {
    }
    let variables: Variables

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {
    let statement: [Statement]

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
    }
}

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    let batchSize: Double?
    let enabled: Bool?
    public struct QueueObject: Codable, Sendable {
    }
    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case itemsString(String)
        case itemObject(QueueObject)
    }

    private enum CodingKeys: String, CodingKey {
        case batchSize = "BatchSize"
        case enabled = "Enabled"
        case queue = "Queue"
    }
}

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let startingPosition: String
    let stream: String
    let batchSize: Double?
    let enabled: Bool?

    private enum CodingKeys: String, CodingKey {
        case startingPosition = "StartingPosition"
        case stream = "Stream"
        case batchSize = "BatchSize"
        case enabled = "Enabled"
    }
}

public struct ServerlessFunction: Codable, Sendable {
    let deletionPolicy: String?
    let updateReplacePolicy: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function
    let condition: String?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }

    private enum CodingKeys: String, CodingKey {
        case deletionPolicy = "DeletionPolicy"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case type = "Type"
        case condition = "Condition"
        case metadata = "Metadata"
        case dependsOn = "DependsOn"
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