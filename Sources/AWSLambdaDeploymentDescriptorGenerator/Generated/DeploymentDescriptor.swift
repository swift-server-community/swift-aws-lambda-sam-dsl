
public struct SAMDeploymentDescriptor: Codable, Sendable {
    public struct Metadata: Codable, Sendable {}

    let metadata: Metadata?
    let resources: [String: Resources]

    public enum Resources: Codable, Sendable {
        case serverlessApi(ServerlessApi)
        case serverlessFunction(ServerlessFunction)
        case serverlessSimpleTable(ServerlessSimpleTable)
        case cloudFormationResource(CloudFormationResource)
    }

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    let awsTemplateFormatVersion: AWSTemplateFormatVersion? = .v2010_09_09

    public struct Globals: Codable, Sendable {}

    let globals: Globals?
    let description: String?

    public struct Properties: Codable, Sendable {}

    let properties: Properties?
    let parameters: [String: Parameter]?

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    let transform: Transform? = .aws_Serverless_2016_10_31

    public struct Outputs: Codable, Sendable {}

    let outputs: [String: Outputs]?

    public struct Mappings: Codable, Sendable {}

    let mappings: [String: Mappings]?

    public struct Conditions: Codable, Sendable {}

    let conditions: [String: Conditions]?

    private enum CodingKeys: String, CodingKey {
        case metadata = "Metadata"
        case resources = "Resources"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case globals = "Globals"
        case description = "Description"
        case properties = "Properties"
        case parameters = "Parameters"
        case transform = "Transform"
        case outputs = "Outputs"
        case mappings = "Mappings"
        case conditions = "Conditions"
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

public struct ServerlessFunctionEventBridgeRule: Codable, Sendable {
    let state: String?
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

    public struct RetryPolicy: Codable, Sendable {
        let maximumRetryAttempts: Double?
        let maximumEventAgeInSeconds: Double?

        private enum CodingKeys: String, CodingKey {
            case maximumRetryAttempts = "MaximumRetryAttempts"
            case maximumEventAgeInSeconds = "MaximumEventAgeInSeconds"
        }
    }

    let retryPolicy: RetryPolicy?
    let inputPath: String?

    public struct Pattern: Codable, Sendable {}

    let pattern: Pattern

    private enum CodingKeys: String, CodingKey {
        case state = "State"
        case ruleName = "RuleName"
        case input = "Input"
        case deadLetterConfig = "DeadLetterConfig"
        case retryPolicy = "RetryPolicy"
        case inputPath = "InputPath"
        case pattern = "Pattern"
    }
}

public struct ServerlessFunctionMSKEvent: Codable, Sendable {
    let stream: String
    let topics: [String]
    let startingPosition: String

    private enum CodingKeys: String, CodingKey {
        case stream = "Stream"
        case topics = "Topics"
        case startingPosition = "StartingPosition"
    }
}

public struct ServerlessFunctionS3NotificationFilter: Codable, Sendable {
    public struct S3KeyObject: Codable, Sendable {}

    let s3Key: [String: S3Key]

    public enum S3Key: Codable, Sendable {
        case item(String)
        case itemObject(S3KeyObject)
    }

    private enum CodingKeys: String, CodingKey {
        case s3Key = "S3Key"
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

public struct ServerlessFunction: Codable, Sendable {
    let properties: [String: Properties]
    public struct Properties: Codable, Sendable {
        let inlineCode: String?
        let codeUri: [String: CodeUri]?

        public enum CodeUri: Codable, Sendable {
            case item(String)
            case serverlessFunctionS3Location(ServerlessFunctionS3Location)
        }

        let events: [String: ServerlessFunctionEventSource]?
        let policies: [String: Policies]?

        public enum Policies: Codable, Sendable {
            case item(String)
            case itemArray([String])
            case serverlessFunctionIAMPolicyDocument(ServerlessFunctionIAMPolicyDocument)
            case serverlessFunctionIAMPolicyDocumentArray([ServerlessFunctionIAMPolicyDocument])
        }

        let timeout: Double?
        let tracing: String?
        public struct RoleObject: Codable, Sendable {}

        let role: [String: Role]?

        public enum Role: Codable, Sendable {
            case item(String)
            case itemObject(RoleObject)
        }

        let deadLetterQueue: ServerlessFunctionDeadLetterQueue?
        let handler: String
        let kmsKeyArn: String?
        let environment: ServerlessFunctionFunctionEnvironment?
        let runtime: String
        let description: String?
        let vpcConfig: ServerlessFunctionVpcConfig?
        let memorySize: Double?
        let tags: [String: String]?
        let functionName: String?

        private enum CodingKeys: String, CodingKey {
            case inlineCode = "InlineCode"
            case codeUri = "CodeUri"
            case events = "Events"
            case policies = "Policies"
            case timeout = "Timeout"
            case tracing = "Tracing"
            case role = "Role"
            case deadLetterQueue = "DeadLetterQueue"
            case handler = "Handler"
            case kmsKeyArn = "KmsKeyArn"
            case environment = "Environment"
            case runtime = "Runtime"
            case description = "Description"
            case vpcConfig = "VpcConfig"
            case memorySize = "MemorySize"
            case tags = "Tags"
            case functionName = "FunctionName"
        }
    }

    let updateReplacePolicy: String?
    let condition: String?

    public struct Metadata: Codable, Sendable {}

    let metadata: Metadata?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Function = "AWS::Serverless::Function"
    }

    let type: `Type` = .aws_Serverless_Function
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    let deletionPolicy: String?

    private enum CodingKeys: String, CodingKey {
        case properties = "Properties"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case condition = "Condition"
        case metadata = "Metadata"
        case type = "Type"
        case dependsOn = "DependsOn"
        case deletionPolicy = "DeletionPolicy"
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

public struct ServerlessFunctionS3Event: Codable, Sendable {
    let events: [String: Events]

    public enum Events: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    let filter: ServerlessFunctionS3NotificationFilter?
    public struct BucketObject: Codable, Sendable {}

    let bucket: [String: Bucket]

    public enum Bucket: Codable, Sendable {
        case item(String)
        case itemObject(BucketObject)
    }

    private enum CodingKeys: String, CodingKey {
        case events = "Events"
        case filter = "Filter"
        case bucket = "Bucket"
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

public struct ServerlessFunctionCloudWatchEventEvent: Codable, Sendable {
    let input: String?
    let eventBusName: String?
    let inputPath: String?

    public struct Pattern: Codable, Sendable {}

    let pattern: Pattern

    private enum CodingKeys: String, CodingKey {
        case input = "Input"
        case eventBusName = "EventBusName"
        case inputPath = "InputPath"
        case pattern = "Pattern"
    }
}

public struct ServerlessFunctionScheduleEvent: Codable, Sendable {
    let enabled: Bool?
    let name: String?
    let input: String?
    let description: String?
    let schedule: String

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case name = "Name"
        case input = "Input"
        case description = "Description"
        case schedule = "Schedule"
    }
}

public struct ServerlessFunctionAlexaSkillEvent: Codable, Sendable {
    let variables: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessFunctionVpcConfig: Codable, Sendable {
    let subnetIds: [String]

    public struct SubnetIdsUsingRef: Codable, Sendable {}

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

public struct Tag: Codable, Sendable {
    public struct ValueObject: Codable, Sendable {}

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

public struct Parameter: Codable, Sendable {
    let minValue: String?
    let noEcho: NoEcho?

    public enum NoEcho: Codable, Sendable {
        case string(String)
        case boolean(Bool)
    }

    let allowedPattern: String?
    let minLength: String?
    let maxLength: String?
    let description: String?
    let maxValue: String?

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
    let `default`: String?
    let allowedValues: [String]?
    let constraintDescription: String?

    private enum CodingKeys: String, CodingKey {
        case minValue = "MinValue"
        case noEcho = "NoEcho"
        case allowedPattern = "AllowedPattern"
        case minLength = "MinLength"
        case maxLength = "MaxLength"
        case description = "Description"
        case maxValue = "MaxValue"
        case type = "Type"
        case `default` = "Default"
        case allowedValues = "AllowedValues"
        case constraintDescription = "ConstraintDescription"
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
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    public struct Metadata: Codable, Sendable {}

    let metadata: Metadata?
    let condition: String?

    private enum CodingKeys: String, CodingKey {
        case deletionPolicy = "DeletionPolicy"
        case properties = "Properties"
        case type = "Type"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case dependsOn = "DependsOn"
        case metadata = "Metadata"
        case condition = "Condition"
    }
}

public struct ServerlessFunctionApiEvent: Codable, Sendable {
    public struct RestApiIdObject: Codable, Sendable {}

    let restApiId: [String: RestApiId]?

    public enum RestApiId: Codable, Sendable {
        case item(String)
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

public struct ServerlessFunctionSQSEvent: Codable, Sendable {
    let enabled: Bool?
    public struct QueueObject: Codable, Sendable {}

    let queue: [String: Queue]

    public enum Queue: Codable, Sendable {
        case item(String)
        case itemObject(QueueObject)
    }

    let batchSize: Double?

    private enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
        case queue = "Queue"
        case batchSize = "BatchSize"
    }
}

public struct ServerlessApi: Codable, Sendable {
    let dependsOn: [String: DependsOn]?

    public enum DependsOn: Codable, Sendable {
        case item(String)
        case itemArray([String])
    }

    public struct Metadata: Codable, Sendable {}

    let metadata: Metadata?

    public enum `Type`: String, Codable, Sendable {
        case aws_Serverless_Api = "AWS::Serverless::Api"
    }

    let type: `Type` = .aws_Serverless_Api

    public struct Properties: Codable, Sendable {
        let definitionUri: [String: DefinitionUri]?

        public enum DefinitionUri: Codable, Sendable {
            case item(String)
            case serverlessApiS3Location(ServerlessApiS3Location)
        }

        public struct VariablesObject: Codable, Sendable {}

        let variables: [String: Variables]?

        public enum Variables: Codable, Sendable {
            case item(String)
            case itemObject(VariablesObject)
        }

        let cacheClusterSize: String?
        let description: String?
        let tracingEnabled: Bool?
        let name: String?
        public struct StageNameObject: Codable, Sendable {}

        let stageName: [String: StageName]

        public enum StageName: Codable, Sendable {
            case item(String)
            case itemObject(StageNameObject)
        }

        public struct DefinitionBody: Codable, Sendable {}

        let definitionBody: DefinitionBody?
        let cacheClusterEnabled: Bool?

        private enum CodingKeys: String, CodingKey {
            case definitionUri = "DefinitionUri"
            case variables = "Variables"
            case cacheClusterSize = "CacheClusterSize"
            case description = "Description"
            case tracingEnabled = "TracingEnabled"
            case name = "Name"
            case stageName = "StageName"
            case definitionBody = "DefinitionBody"
            case cacheClusterEnabled = "CacheClusterEnabled"
        }
    }

    let properties: Properties
    let deletionPolicy: String?
    let updateReplacePolicy: String?
    let condition: String?

    private enum CodingKeys: String, CodingKey {
        case dependsOn = "DependsOn"
        case metadata = "Metadata"
        case type = "Type"
        case properties = "Properties"
        case deletionPolicy = "DeletionPolicy"
        case updateReplacePolicy = "UpdateReplacePolicy"
        case condition = "Condition"
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

public struct ServerlessSimpleTablePrimaryKey: Codable, Sendable {
    let type: String
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case name = "Name"
    }
}

public struct ServerlessFunctionSNSEvent: Codable, Sendable {
    let topic: String

    public struct FilterPolicy: Codable, Sendable {}

    let filterPolicy: FilterPolicy?
    let filterPolicyScope: String?
    let region: String?

    private enum CodingKeys: String, CodingKey {
        case topic = "Topic"
        case filterPolicy = "FilterPolicy"
        case filterPolicyScope = "FilterPolicyScope"
        case region = "Region"
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

public struct ServerlessFunctionCognitoEvent: Codable, Sendable {
    public struct UserPoolObject: Codable, Sendable {}

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

public struct ServerlessFunctionIAMPolicyDocument: Codable, Sendable {
    public struct Statement: Codable, Sendable {}

    let statement: [Statement]

    private enum CodingKeys: String, CodingKey {
        case statement = "Statement"
    }
}

public struct ServerlessFunctionFunctionEnvironment: Codable, Sendable {
    let variables: [String: String]

    private enum CodingKeys: String, CodingKey {
        case variables = "Variables"
    }
}

public struct ServerlessSimpleTableSSESpecification: Codable, Sendable {
    let sseEnabled: Bool

    private enum CodingKeys: String, CodingKey {
        case sseEnabled = "SSEEnabled"
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

public struct CloudFormationResource: Codable, Sendable {
    let type: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
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
