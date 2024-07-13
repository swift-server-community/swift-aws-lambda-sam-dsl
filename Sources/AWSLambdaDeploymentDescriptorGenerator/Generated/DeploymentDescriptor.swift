
public struct SAMDeploymentDescriptor: Codable, Sendable {
    let transform: Transform? = .aws_Serverless_2016_10_31

    public struct Mappings: Codable, Sendable {
    }
    let mappings: Mappings?
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }

    public struct Outputs: Codable, Sendable {
    }
    let outputs: Outputs?
    let parameters: Parameter?
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09

    public struct Conditions: Codable, Sendable {
    }
    let conditions: Conditions?

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    private enum CodingKeys: String, CodingKey {
        case transform = "Transform"
        case mappings = "Mappings"
        case resources = "Resources"
        case outputs = "Outputs"
        case parameters = "Parameters"
        case description = "Description"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case conditions = "Conditions"
    }
}

public struct ServerlessFunctionMSKEvent: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case stream = "Stream"
        case topics = "Topics"
        case startingPosition = "StartingPosition"
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

public struct ServerlessSimpleTableProvisionedThroughput: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case readCapacityUnits = "ReadCapacityUnits"
        case writeCapacityUnits = "WriteCapacityUnits"
    }
}

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
    }
}

public struct ServerlessFunctionMQEvent: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case queues = "Queues"
        case sourceAccessConfigurations = "SourceAccessConfigurations"
        case broker = "Broker"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {

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

public struct ServerlessSimpleTablePrimaryKey: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
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

    private enum CodingKeys: String, CodingKey {
        case value = "Value"
        case key = "Key"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {

    public struct FilterPolicy: Codable, Sendable {
    }
    let filterPolicy: FilterPolicy?

    private enum CodingKeys: String, CodingKey {
        case filterPolicyScope = "FilterPolicyScope"
        case topic = "Topic"
        case filterPolicy = "FilterPolicy"
        case region = "Region"
    }
}

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    public struct QueueObject: Codable, Sendable {
    }
    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case itemsString(String)
        case itemObject(QueueObject)
    }

    private enum CodingKeys: String, CodingKey {
        case queue = "Queue"
        case batchSize = "BatchSize"
        case enabled = "Enabled"
    }
}

public struct ServerlessFunctionLogEvent: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case filterPattern = "FilterPattern"
        case logGroupName = "LogGroupName"
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

public struct ServerlessFunctionDeadLetterQueue: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case targetArn = "TargetArn"
    }
}

public struct ServerlessFunction: Codable, Sendable {
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function

    private enum CodingKeys: String, CodingKey {
        case dependsOn = "DependsOn"
        case deletionPolicy = "DeletionPolicy"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case metadata = "Metadata"
        case type = "Type"
        case condition = "Condition"
    }
}

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case startingPosition = "StartingPosition"
        case batchSize = "BatchSize"
        case stream = "Stream"
    }
}

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case stream = "Stream"
        case startingPosition = "StartingPosition"
        case batchSize = "BatchSize"
    }
}

public struct ServerlessFunctionVpcConfig: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case subnetIds = "SubnetIds"
        case subnetIdsUsingRef = "SubnetIdsUsingRef"
        case securityGroupIds = "SecurityGroupIds"
    }
}

public struct ServerlessFunctionS3Location: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case bucket = "Bucket"
        case version = "Version"
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

    private enum CodingKeys: String, CodingKey {
        case properties = "Properties"
        case type = "Type"
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

public struct ServerlessSimpleTable: Codable, Sendable {

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let properties: Properties?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }

    private enum CodingKeys: String, CodingKey {
        case condition = "Condition"
        case metadata = "Metadata"
        case properties = "Properties"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case deletionPolicy = "DeletionPolicy"
        case type = "Type"
        case dependsOn = "DependsOn"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case schedule = "Schedule"
        case description = "Description"
        case input = "Input"
        case enabled = "Enabled"
        case name = "Name"
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

    private enum CodingKeys: String, CodingKey {
        case minValue = "MinValue"
        case minLength = "MinLength"
        case maxValue = "MaxValue"
        case maxLength = "MaxLength"
        case `default` = "Default"
        case constraintDescription = "ConstraintDescription"
        case allowedPattern = "AllowedPattern"
        case description = "Description"
        case noEcho = "NoEcho"
        case type = "Type"
        case allowedValues = "AllowedValues"
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

public struct ServerlessApiS3Location: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case bucket = "Bucket"
    }
}

public struct ServerlessFunctionIoTRuleEvent: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case sql = "Sql"
        case awsIotSqlVersion = "AwsIotSqlVersion"
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

    private enum CodingKeys: String, CodingKey {
        case path = "Path"
        case method = "Method"
        case restApiId = "RestApiId"
    }
}

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {

    public struct Pattern: Codable, Sendable {
    }
    let pattern: Pattern
    let retryPolicy: RetryPolicy?
    let deadLetterConfig: DeadLetterConfig?

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case pattern = "Pattern"
        case state = "State"
        case retryPolicy = "RetryPolicy"
        case inputPath = "InputPath"
        case deadLetterConfig = "DeadLetterConfig"
        case ruleName = "RuleName"
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
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemsString(String)
        case items([String])
    }
    let properties: Properties

    private enum CodingKeys: String, CodingKey {
        case condition = "Condition"
        case type = "Type"
        case metadata = "Metadata"
        case deletionPolicy = "DeletionPolicy"
        case dependsOn = "DependsOn"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case properties = "Properties"
    }
}

public struct CloudFormationResource: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
}

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
    }
}