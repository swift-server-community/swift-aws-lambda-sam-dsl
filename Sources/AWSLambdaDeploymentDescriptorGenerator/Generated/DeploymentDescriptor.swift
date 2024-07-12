
public struct SAMDeploymentDescriptor: Codable, Sendable {
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09
    let parameters: Parameters?
    let transform: Transform? = .aws_Serverless_2016_10_31
    let outputs: Outputs?
    let conditions: Conditions?
    let mappings: Mappings?
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }
    let description: String?

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    private enum CodingKeys: String, CodingKey {
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case parameters = "Parameters"
        case transform = "Transform"
        case outputs = "Outputs"
        case conditions = "Conditions"
        case mappings = "Mappings"
        case resources = "Resources"
        case description = "Description"
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
    let sourceAccessConfigurations: [Any]
    let queues: [Any]

    private enum CodingKeys: String, CodingKey {
        case broker = "Broker"
        case sourceAccessConfigurations = "SourceAccessConfigurations"
        case queues = "Queues"
    }
}

public struct ServerlessFunctionS3Event: Codable, Sendable {
    let events: [String: Events]

    public enum Events: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }
    public struct BucketObject: Codable, Sendable {
    }
    let bucket: [String: Bucket]

    public enum Bucket: Codable, Sendable {
        case itemsString(String)
        case itemObject(BucketObject)
    }
    let filter: ServerlessFunctionS3NotificationFilter?

    private enum CodingKeys: String, CodingKey {
        case events = "Events"
        case bucket = "Bucket"
        case filter = "Filter"
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

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: Variables?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let enabled: Bool?
    let description: String?
    let schedule: String
    let name: String?
    let input: String?

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case description = "Description"
        case schedule = "Schedule"
        case name = "Name"
        case input = "Input"
    }
}

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
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

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let startingPosition: String
    let enabled: Bool?
    let batchSize: Double?
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case startingPosition = "StartingPosition"
        case enabled = "Enabled"
        case batchSize = "BatchSize"
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

public struct ServerlessFunctionIoTRuleEvent: Codable, Sendable {
    let sql: String
    let awsIotSqlVersion: String?

    private enum CodingKeys: String, CodingKey {
        case sql = "Sql"
        case awsIotSqlVersion = "AwsIotSqlVersion"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let input: String?
    let pattern: Pattern
    let inputPath: String?
    let eventBusName: String?

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case pattern = "Pattern"
        case inputPath = "InputPath"
        case eventBusName = "EventBusName"
    }
}

public struct ServerlessApi: Codable, Sendable {
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api
    let deletionPolicy: String?
    let condition: String?
    let metadata: Metadata?
    let updateReplacePolicy: String?
    let properties: Properties

    private enum CodingKeys: String, CodingKey {
        case dependsOn = "DependsOn"
        case type = "Type"
        case deletionPolicy = "DeletionPolicy"
        case condition = "Condition"
        case metadata = "Metadata"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case properties = "Properties"
    }
}

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
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

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: Variables

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessFunction: Codable, Sendable {
    let deletionPolicy: String?
    let updateReplacePolicy: String?
    let condition: String?
    let metadata: Metadata?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }

    private enum CodingKeys: String, CodingKey {
        case deletionPolicy = "DeletionPolicy"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case condition = "Condition"
        case metadata = "Metadata"
        case type = "Type"
        case dependsOn = "DependsOn"
    }
}

public struct ServerlessSimpleTable: Codable, Sendable {
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }
    let condition: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable
    let updateReplacePolicy: String?
    let properties: Properties?
    let metadata: Metadata?
    let deletionPolicy: String?

    private enum CodingKeys: String, CodingKey {
        case dependsOn = "DependsOn"
        case condition = "Condition"
        case type = "Type"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case properties = "Properties"
        case metadata = "Metadata"
        case deletionPolicy = "DeletionPolicy"
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

public struct Parameter: Codable, Sendable {
    let allowedValues: [Any]?
    let noEcho: not supported yet ⚠️?
    let constraintDescription: String?
    let allowedPattern: String?
    let default: String?
    let minLength: String?
    let minValue: String?
    let maxValue: String?

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
    let maxLength: String?
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case allowedValues = "AllowedValues"
        case noEcho = "NoEcho"
        case constraintDescription = "ConstraintDescription"
        case allowedPattern = "AllowedPattern"
        case default = "Default"
        case minLength = "MinLength"
        case minValue = "MinValue"
        case maxValue = "MaxValue"
        case type = "Type"
        case maxLength = "MaxLength"
        case description = "Description"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {
    let region: String?
    let filterPolicy: FilterPolicy?
    let topic: String
    let filterPolicyScope: String?

    private enum CodingKeys: String, CodingKey {
        case region = "Region"
        case filterPolicy = "FilterPolicy"
        case topic = "Topic"
        case filterPolicyScope = "FilterPolicyScope"
    }
}

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let enabled: Bool?
    let batchSize: Double
    let stream: String
    let startingPosition: String

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case batchSize = "BatchSize"
        case stream = "Stream"
        case startingPosition = "StartingPosition"
    }
}

public struct ServerlessFunctionMSKEvent: Codable, Sendable {
    let startingPosition: String
    let stream: String
    let topics: [Any]

    private enum CodingKeys: String, CodingKey {
        case startingPosition = "StartingPosition"
        case stream = "Stream"
        case topics = "Topics"
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

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    let path: String
    let method: String
    public struct RestApiIdObject: Codable, Sendable {
    }
    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case itemsString(String)
        case itemObject(RestApiIdObject)
    }

    private enum CodingKeys: String, CodingKey {
        case path = "Path"
        case method = "Method"
        case restApiId = "RestApiId"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
    let inputPath: String?
    let state: String?
    let input: String?
    let retryPolicy: RetryPolicy?
    let ruleName: String?
    let deadLetterConfig: DeadLetterConfig?
    let pattern: Pattern

    private enum CodingKeys: String, CodingKey {
        case inputPath = "InputPath"
        case state = "State"
        case input = "Input"
        case retryPolicy = "RetryPolicy"
        case ruleName = "RuleName"
        case deadLetterConfig = "DeadLetterConfig"
        case pattern = "Pattern"
    }
}