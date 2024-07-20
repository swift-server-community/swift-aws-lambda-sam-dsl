
public struct SAMDeploymentDescriptor: Codable, Sendable {
    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }
    let parameters: [String: Parameter]?
    let outputs: [String: Outputs]?

    public struct Outputs: Codable, Sendable {
    }
    let transform: Transform? = .aws_Serverless_2016_10_31
    let description: String?
    let conditions: [String: Conditions]?

    public struct Conditions: Codable, Sendable {
    }
    let mappings: [String: Mappings]?

    public struct Mappings: Codable, Sendable {
    }

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    private enum CodingKeys: String, CodingKey {
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case resources = "Resources"
        case parameters = "Parameters"
        case outputs = "Outputs"
        case transform = "Transform"
        case description = "Description"
        case conditions = "Conditions"
        case mappings = "Mappings"
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

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
    }
}

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let input: String?

    public struct Pattern: Codable, Sendable {
    }
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

public struct ServerlessFunctionDeadLetterQueue: Codable, Sendable {
    let targetArn: String
    let type: String

    private enum CodingKeys: String, CodingKey {
        case targetArn = "TargetArn"
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

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
    let input: String?

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
    let ruleName: String?
    let inputPath: String?
    let state: String?

    public struct DeadLetterConfig: Codable, Sendable {
        let queueLogicalId: String?
        let arn: String?
        let type: String?

        private enum CodingKeys: String, CodingKey {
            case queueLogicalId = "QueueLogicalId"
            case arn = "Arn"
            case type = "Type"
        }
    }
    let deadLetterConfig: DeadLetterConfig?

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case retryPolicy = "RetryPolicy"
        case pattern = "Pattern"
        case ruleName = "RuleName"
        case inputPath = "InputPath"
        case state = "State"
        case deadLetterConfig = "DeadLetterConfig"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let description: String?
    let name: String?
    let schedule: String
    let input: String?
    let enabled: Bool?

    private enum CodingKeys: String, CodingKey {
        case description = "Description"
        case name = "Name"
        case schedule = "Schedule"
        case input = "Input"
        case enabled = "Enabled"
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

public struct ServerlessFunctionKinesisEvent: Codable, Sendable {
    let startingPosition: String
    let enabled: Bool?
    let stream: String
    let batchSize: Double?

    private enum CodingKeys: String, CodingKey {
        case startingPosition = "StartingPosition"
        case enabled = "Enabled"
        case stream = "Stream"
        case batchSize = "BatchSize"
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
    let deletionPolicy: String?
    let properties: [String: Properties]
    public struct Properties: Codable, Sendable {
        let inlineCode: String?
        let codeUri: [String: CodeUri]?

        public enum CodeUri: Codable, Sendable {
            case itemString(String)
            case serverlessFunctionS3Location(ServerlessFunctionS3Location)
        }
        let environment: ServerlessFunctionFunctionEnvironment?
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
        let description: String?
        let timeout: Double?
        let tracing: String?
        let functionName: String?
        let handler: String
        let deadLetterQueue: ServerlessFunctionDeadLetterQueue?
        let runtime: String
        let vpcConfig: ServerlessFunctionVpcConfig?
        let events: [String: Events]?

        public enum Events: Codable, Sendable {
            case serverlessFunctionEventSource(ServerlessFunctionEventSource)
        }
        let memorySize: Double?
        let tags: [String: String]?
        let kmsKeyArn: String?

        private enum CodingKeys: String, CodingKey {
            case inlineCode = "InlineCode"
            case codeUri = "CodeUri"
            case environment = "Environment"
            case policies = "Policies"
            case role = "Role"
            case description = "Description"
            case timeout = "Timeout"
            case tracing = "Tracing"
            case functionName = "FunctionName"
            case handler = "Handler"
            case deadLetterQueue = "DeadLetterQueue"
            case runtime = "Runtime"
            case vpcConfig = "VpcConfig"
            case events = "Events"
            case memorySize = "MemorySize"
            case tags = "Tags"
            case kmsKeyArn = "KmsKeyArn"
        }
    }

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    let updateReplacePolicy: String?
    let condition: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }
    let type: `Type` = .aws_Serverless_Function

    private enum CodingKeys: String, CodingKey {
        case deletionPolicy = "DeletionPolicy"
        case properties = "Properties"
        case metadata = "Metadata"
        case dependsOn = "DependsOn"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case condition = "Condition"
        case type = "Type"
    }
}

public struct ServerlessFunctionVpcConfig: Codable, Sendable {
    let subnetIds: [String]
    let securityGroupIds: [String]

    public struct SubnetIdsUsingRef: Codable, Sendable {
    }
    let subnetIdsUsingRef: [SubnetIdsUsingRef]?

    private enum CodingKeys: String, CodingKey {
        case subnetIds = "SubnetIds"
        case securityGroupIds = "SecurityGroupIds"
        case subnetIdsUsingRef = "SubnetIdsUsingRef"
    }
}

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
}

public struct ServerlessFunctionDynamoDBEvent: Codable, Sendable {
    let batchSize: Double
    let stream: String
    let startingPosition: String
    let enabled: Bool?

    private enum CodingKeys: String, CodingKey {
        case batchSize = "BatchSize"
        case stream = "Stream"
        case startingPosition = "StartingPosition"
        case enabled = "Enabled"
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

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    let batchSize: Double?
    public struct QueueObject: Codable, Sendable {
    }
    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case itemString(String)
        case itemObject(QueueObject)
    }
    let enabled: Bool?

    private enum CodingKeys: String, CodingKey {
        case batchSize = "BatchSize"
        case queue = "Queue"
        case enabled = "Enabled"
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

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Simpletable = "AWS::Serverless::SimpleTable"
    }
    let type: `Type` = .aws_Serverless_Simpletable
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

    private enum CodingKeys: String, CodingKey {
        case properties = "Properties"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case type = "Type"
        case dependsOn = "DependsOn"
        case metadata = "Metadata"
        case deletionPolicy = "DeletionPolicy"
        case condition = "Condition"
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

public struct ServerlessFunctionMQEvent: Codable, Sendable {
    let sourceAccessConfigurations: [String]
    let broker: String
    let queues: [String]

    private enum CodingKeys: String, CodingKey {
        case sourceAccessConfigurations = "SourceAccessConfigurations"
        case broker = "Broker"
        case queues = "Queues"
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

public struct ServerlessFunctionIoTRuleEvent: Codable, Sendable {
    let sql: String
    let awsIotSqlVersion: String?

    private enum CodingKeys: String, CodingKey {
        case sql = "Sql"
        case awsIotSqlVersion = "AwsIotSqlVersion"
    }
}

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: [String: String]

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
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

public struct Parameter: Codable, Sendable {
    let noEcho: not supported yet ⚠️?
    let `default`: String?
    let description: String?
    let allowedValues: [String]?
    let minLength: String?
    let maxLength: String?
    let minValue: String?
    let allowedPattern: String?
    let constraintDescription: String?
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

    private enum CodingKeys: String, CodingKey {
        case noEcho = "NoEcho"
        case `default` = "Default"
        case description = "Description"
        case allowedValues = "AllowedValues"
        case minLength = "MinLength"
        case maxLength = "MaxLength"
        case minValue = "MinValue"
        case allowedPattern = "AllowedPattern"
        case constraintDescription = "ConstraintDescription"
        case maxValue = "MaxValue"
        case type = "Type"
    }
}

public struct ServerlessApi: Codable, Sendable {
    let condition: String?

    public struct Properties: Codable, Sendable {

        public struct DefinitionBody: Codable, Sendable {
        }
        let definitionBody: DefinitionBody?
        let cacheClusterSize: String?
        let description: String?
        let name: String?
        let cacheClusterEnabled: Bool?
        public struct StageNameObject: Codable, Sendable {
        }
        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case itemString(String)
            case itemObject(StageNameObject)
        }
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case itemString(String)
            case serverlessApiS3Location(ServerlessApiS3Location)
        }
        public struct VariablesObject: Codable, Sendable {
        }
        let variables: [String: Variables]?

        public enum Variables: Codable, Sendable {
            case itemString(String)
            case itemObject(VariablesObject)
        }
        let tracingEnabled: Bool?

        private enum CodingKeys: String, CodingKey {
            case definitionBody = "DefinitionBody"
            case cacheClusterSize = "CacheClusterSize"
            case description = "Description"
            case name = "Name"
            case cacheClusterEnabled = "CacheClusterEnabled"
            case stageName = "StageName"
            case definitionUri = "DefinitionUri"
            case variables = "Variables"
            case tracingEnabled = "TracingEnabled"
        }
    }
    let properties: Properties
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case itemString(String)
        case items([String])
    }
    let updateReplacePolicy: String?
    let deletionPolicy: String?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }
    let type: `Type` = .aws_Serverless_Api

    public struct Metadata: Codable, Sendable {
    }
    let metadata: Metadata?

    private enum CodingKeys: String, CodingKey {
        case condition = "Condition"
        case properties = "Properties"
        case dependsOn = "DependsOn"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case deletionPolicy = "DeletionPolicy"
        case type = "Type"
        case metadata = "Metadata"
    }
}