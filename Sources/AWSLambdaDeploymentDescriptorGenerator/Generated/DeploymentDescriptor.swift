
public struct SAMDeploymentDescriptor: Codable, Sendable {
    let transform: Transform? = .aws_Serverless_2016_10_31
    let parameters: Parameters?
    let resources: [String: Resources]

    public enum Resources: String, Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }
    let conditions: Conditions?
    let outputs: Outputs?
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09
    let description: String?
    let mappings: Mappings?

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    private enum CodingKeys: String, CodingKey {
        case transform = "Transform"
        case parameters = "Parameters"
        case resources = "Resources"
        case conditions = "Conditions"
        case outputs = "Outputs"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case description = "Description"
        case mappings = "Mappings"
    }
}

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: Variables?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    let enabled: Bool?
    let queue: [String: Queue]

    public enum Queue: String, Codable, Sendable {
        case type(String)
    }
    let batchSize: Double?

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case queue = "Queue"
        case batchSize = "BatchSize"
    }
}

public struct ServerlessFunctionS3Event: Codable, Sendable {
    let events: [String: Events]

    public enum Events: String, Codable, Sendable {
        case type(String)
    }
    let bucket: [String: Bucket]

    public enum Bucket: String, Codable, Sendable {
        case type(String)
    }
    let filter: not supported yet ⚠️?

    private enum CodingKeys: String, CodingKey {
        case events = "Events"
        case bucket = "Bucket"
        case filter = "Filter"
    }
}

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: Variables

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let eventBusName: String?
    let inputPath: String?
    let pattern: Pattern
    let input: String?

    private enum CodingKeys: String, CodingKey {
        case eventBusName = "EventBusName"
        case inputPath = "InputPath"
        case pattern = "Pattern"
        case input = "Input"
    }
}

public struct Tag: Codable, Sendable {
    let value: [String: Value]?

    public enum Value: String, Codable, Sendable {
        case type(String)
    }
    let key: String?

    private enum CodingKeys: String, CodingKey {
        case value = "Value"
        case key = "Key"
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

public struct ServerlessFunctionLogEvent: Codable, Sendable {
    let filterPattern: String
    let logGroupName: String

    private enum CodingKeys: String, CodingKey {
        case filterPattern = "FilterPattern"
        case logGroupName = "LogGroupName"
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

public struct ServerlessSimpleTableProvisionedThroughput: Codable, Sendable {
    let writeCapacityUnits: Double
    let readCapacityUnits: Double?

    private enum CodingKeys: String, CodingKey {
        case writeCapacityUnits = "WriteCapacityUnits"
        case readCapacityUnits = "ReadCapacityUnits"
    }
}

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
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

public struct ServerlessFunction: Codable, Sendable {
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: String, Codable, Sendable {
        case type(String)
    }

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function
    let condition: String?
    let updateReplacePolicy: String?
    let metadata: Metadata?
    let deletionPolicy: String?

    private enum CodingKeys: String, CodingKey {
        case dependsOn = "DependsOn"
        case type = "Type"
        case condition = "Condition"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case metadata = "Metadata"
        case deletionPolicy = "DeletionPolicy"
    }
}

public struct Parameter: Codable, Sendable {
    let maxValue: String?
    let allowedPattern: String?
    let allowedValues: [Any]?

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
    let minValue: String?
    let noEcho: not supported yet ⚠️?
    let maxLength: String?
    let default: String?
    let description: String?
    let constraintDescription: String?
    let minLength: String?

    private enum CodingKeys: String, CodingKey {
        case maxValue = "MaxValue"
        case allowedPattern = "AllowedPattern"
        case allowedValues = "AllowedValues"
        case type = "Type"
        case minValue = "MinValue"
        case noEcho = "NoEcho"
        case maxLength = "MaxLength"
        case default = "Default"
        case description = "Description"
        case constraintDescription = "ConstraintDescription"
        case minLength = "MinLength"
    }
}

public struct ServerlessApi: Codable, Sendable {
    let condition: String?
    let properties: Properties
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: String, Codable, Sendable {
        case type(String)
    }
    let deletionPolicy: String?
    let updateReplacePolicy: String?
    let metadata: Metadata?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api

    private enum CodingKeys: String, CodingKey {
        case condition = "Condition"
        case properties = "Properties"
        case dependsOn = "DependsOn"
        case deletionPolicy = "DeletionPolicy"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case metadata = "Metadata"
        case type = "Type"
    }
}

public struct ServerlessFunctionS3NotificationFilter: Codable, Sendable {
    let s3Key: [String: S3Key]

    public enum S3Key: String, Codable, Sendable {
        case type(String)
    }

    private enum CodingKeys: String, CodingKey {
        case s3Key = "S3Key"
    }
}

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let enabled: Bool?
    let batchSize: Double?
    let startingPosition: String
    let stream: String

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case batchSize = "BatchSize"
        case startingPosition = "StartingPosition"
        case stream = "Stream"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {
    let filterPolicyScope: String?
    let topic: String
    let region: String?
    let filterPolicy: FilterPolicy?

    private enum CodingKeys: String, CodingKey {
        case filterPolicyScope = "FilterPolicyScope"
        case topic = "Topic"
        case region = "Region"
        case filterPolicy = "FilterPolicy"
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

public struct ServerlessFunctionDeadLetterQueue: Codable, Sendable {
    let type: String
    let targetArn: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case targetArn = "TargetArn"
    }
}

public struct ServerlessFunctionMQEvent: Codable, Sendable {
    let sourceAccessConfigurations: [Any]
    let broker: String
    let queues: [Any]

    private enum CodingKeys: String, CodingKey {
        case sourceAccessConfigurations = "SourceAccessConfigurations"
        case broker = "Broker"
        case queues = "Queues"
    }
}

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {
    let statement: [Statement]

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
    }
}

public struct ServerlessFunctionCognitoEvent: Codable, Sendable {
    let trigger: [String: Trigger]

    public enum Trigger: String, Codable, Sendable {
        case type(String)
    }
    let userPool: [String: UserPool]

    public enum UserPool: String, Codable, Sendable {
        case type(String)
    }

    private enum CodingKeys: String, CodingKey {
        case trigger = "Trigger"
        case userPool = "UserPool"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let input: String?
    let enabled: Bool?
    let name: String?
    let schedule: String
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case enabled = "Enabled"
        case name = "Name"
        case schedule = "Schedule"
        case description = "Description"
    }
}

public struct ServerlessFunctionEventSource: Codable, Sendable {
    let properties: [String: Properties]

    public enum Properties: String, Codable, Sendable {
    }
    let type: String

    private enum CodingKeys: String, CodingKey {
        case properties = "Properties"
        case type = "Type"
    }
}

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
    }
}

public struct ServerlessSimpleTable: Codable, Sendable {
    let properties: Properties?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: String, Codable, Sendable {
        case type(String)
    }

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable
    let condition: String?
    let deletionPolicy: String?
    let metadata: Metadata?
    let updateReplacePolicy: String?

    private enum CodingKeys: String, CodingKey {
        case properties = "Properties"
        case dependsOn = "DependsOn"
        case type = "Type"
        case condition = "Condition"
        case deletionPolicy = "DeletionPolicy"
        case metadata = "Metadata"
        case updateReplacePolicy = "UpdateReplacePolicy"
    }
}

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    let path: String
    let restApiId: [String: RestApiId]?

    public enum RestApiId: String, Codable, Sendable {
        case type(String)
    }
    let method: String

    private enum CodingKeys: String, CodingKey {
        case path = "Path"
        case restApiId = "RestApiId"
        case method = "Method"
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

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
    let pattern: Pattern
    let ruleName: String?
    let retryPolicy: RetryPolicy?
    let inputPath: String?
    let input: String?
    let deadLetterConfig: DeadLetterConfig?
    let state: String?

    private enum CodingKeys: String, CodingKey {
        case pattern = "Pattern"
        case ruleName = "RuleName"
        case retryPolicy = "RetryPolicy"
        case inputPath = "InputPath"
        case input = "Input"
        case deadLetterConfig = "DeadLetterConfig"
        case state = "State"
    }
}