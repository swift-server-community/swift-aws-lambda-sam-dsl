
public struct SAMDeploymentDescriptor: Codable, Sendable {
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }

    public struct Parameters: Codable, Sendable {
    }
    let parameters: Parameters?

    public struct Mappings: Codable, Sendable {
    }
    let mappings: Mappings?

    public struct Conditions: Codable, Sendable {
    }
    let conditions: Conditions?
    let transform: Transform? = .aws_Serverless_2016_10_31

    public struct Outputs: Codable, Sendable {
    }
    let outputs: Outputs?
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09
    let description: String?

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    private enum CodingKeys: String, CodingKey {
        case resources = "Resources"
        case parameters = "Parameters"
        case mappings = "Mappings"
        case conditions = "Conditions"
        case transform = "Transform"
        case outputs = "Outputs"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case description = "Description"
    }
}

public struct ServerlessFunctionMQEvent: Codable, Sendable {
    let broker: String
    let sourceAccessConfigurations: [Any]
    let queues: [Any]

    private enum CodingKeys: String, CodingKey {
        case broker = "Broker"
        case sourceAccessConfigurations = "SourceAccessConfigurations"
        case queues = "Queues"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let enabled: Bool?
    let input: String?
    let description: String?
    let name: String?
    let schedule: String

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case input = "Input"
        case description = "Description"
        case name = "Name"
        case schedule = "Schedule"
    }
}

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    let batchSize: Double?
    public struct QueueObject: Codable, Sendable {
    }
    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case itemsString(String)
        case itemObject(QueueObject)
    }
    let enabled: Bool?

    private enum CodingKeys: String, CodingKey {
        case batchSize = "BatchSize"
        case queue = "Queue"
        case enabled = "Enabled"
    }
}

public struct ServerlessSimpleTable: Codable, Sendable {
    let updateReplacePolicy: String?
    let deletionPolicy: String?

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let condition: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }

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
        case updateReplacePolicy = "UpdateReplacePolicy"
        case deletionPolicy = "DeletionPolicy"
        case metadata = "Metadata"
        case condition = "Condition"
        case type = "Type"
        case dependsOn = "DependsOn"
        case properties = "Properties"
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

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {
    let statement: [Statement]

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {
    let region: String?
    let topic: String
    let filterPolicyScope: String?

    public struct FilterPolicy: Codable, Sendable {
    }
    let filterPolicy: FilterPolicy?

    private enum CodingKeys: String, CodingKey {
        case region = "Region"
        case topic = "Topic"
        case filterPolicyScope = "FilterPolicyScope"
        case filterPolicy = "FilterPolicy"
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

public struct ServerlessSimpleTableProvisionedThroughput: Codable, Sendable {
    let writeCapacityUnits: Double
    let readCapacityUnits: Double?

    private enum CodingKeys: String, CodingKey {
        case writeCapacityUnits = "WriteCapacityUnits"
        case readCapacityUnits = "ReadCapacityUnits"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let inputPath: String?
    let input: String?
    let eventBusName: String?

    private enum CodingKeys: String, CodingKey {
        case pattern = "Pattern"
        case inputPath = "InputPath"
        case input = "Input"
        case eventBusName = "EventBusName"
    }
}

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    let path: String
    public struct RestApiIdObject: Codable, Sendable {
    }
    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case itemsString(String)
        case itemObject(RestApiIdObject)
    }
    let method: String

    private enum CodingKeys: String, CodingKey {
        case path = "Path"
        case restApiId = "RestApiId"
        case method = "Method"
    }
}

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let enabled: Bool?
    let stream: String
    let startingPosition: String
    let batchSize: Double

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case stream = "Stream"
        case startingPosition = "StartingPosition"
        case batchSize = "BatchSize"
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

public struct ServerlessFunctionDeadLetterQueue: Codable, Sendable {
    let type: String
    let targetArn: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case targetArn = "TargetArn"
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

public struct ServerlessFunctionCognitoEvent: Codable, Sendable {
    public struct UserPoolObject: Codable, Sendable {
    }
    let userPool: [String: UserPool]

    public enum UserPool: Codable, Sendable {
        case itemsString(String)
        case itemObject(UserPoolObject)
    }
    let trigger: [String: Trigger]

    public enum Trigger: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }

    private enum CodingKeys: String, CodingKey {
        case userPool = "UserPool"
        case trigger = "Trigger"
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

public struct ServerlessFunction: Codable, Sendable {
    let deletionPolicy: String?
    let condition: String?
    let updateReplacePolicy: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function
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
        case condition = "Condition"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case type = "Type"
        case dependsOn = "DependsOn"
        case metadata = "Metadata"
    }
}

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
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
    let input: String?
    let inputPath: String?
    let state: String?

    private enum CodingKeys: String, CodingKey {
        case ruleName = "RuleName"
        case deadLetterConfig = "DeadLetterConfig"
        case retryPolicy = "RetryPolicy"
        case pattern = "Pattern"
        case input = "Input"
        case inputPath = "InputPath"
        case state = "State"
    }
}

public struct ServerlessFunctionMSKEvent: Codable, Sendable {
    let topics: [Any]
    let startingPosition: String
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case topics = "Topics"
        case startingPosition = "StartingPosition"
        case stream = "Stream"
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

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {

    public struct Variables: Codable, Sendable {
    }
    let variables: Variables

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct Parameter: Codable, Sendable {
    let description: String?
    let allowedPattern: String?
    let noEcho: not supported yet ⚠️?

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
    let maxLength: String?
    let minLength: String?
    let constraintDescription: String?
    let `default`: String?
    let minValue: String?
    let allowedValues: [Any]?

    private enum CodingKeys: String, CodingKey {
        case description = "Description"
        case allowedPattern = "AllowedPattern"
        case noEcho = "NoEcho"
        case type = "Type"
        case maxValue = "MaxValue"
        case maxLength = "MaxLength"
        case minLength = "MinLength"
        case constraintDescription = "ConstraintDescription"
        case `default` = "Default"
        case minValue = "MinValue"
        case allowedValues = "AllowedValues"
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

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {

    public struct Variables: Codable, Sendable {
    }
    let variables: Variables?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct ServerlessApi: Codable, Sendable {

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let condition: String?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }

    public struct Properties: Codable, Sendable {
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case itemsString(String)
            case serverlessApiS3Location(ServerlessApiS3Location?)
        }
        let cacheClusterEnabled: Bool?
        let tracingEnabled: Bool?

        public struct Variables: Codable, Sendable {
        }
        let variables: Variables?

        public struct DefinitionBody: Codable, Sendable {
        }
        let definitionBody: DefinitionBody?
        let cacheClusterSize: String?
        public struct StageNameObject: Codable, Sendable {
        }
        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case itemsString(String)
            case itemObject(StageNameObject)
        }
        let name: String?
        let description: String?

        private enum CodingKeys: String, CodingKey {
            case definitionUri = "DefinitionUri"
            case cacheClusterEnabled = "CacheClusterEnabled"
            case tracingEnabled = "TracingEnabled"
            case variables = "Variables"
            case definitionBody = "DefinitionBody"
            case cacheClusterSize = "CacheClusterSize"
            case stageName = "StageName"
            case name = "Name"
            case description = "Description"
        }
    }
    let properties: Properties
    let deletionPolicy: String?
    let updateReplacePolicy: String?

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case metadata = "Metadata"
        case condition = "Condition"
        case dependsOn = "DependsOn"
        case properties = "Properties"
        case deletionPolicy = "DeletionPolicy"
        case updateReplacePolicy = "UpdateReplacePolicy"
    }
}