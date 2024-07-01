public struct Property: Codable, Sendable {
    let description: String
    let conditions: Conditions
    let transform: Transform = .aws_Serverless_2016_10_31
    let mappings: Mappings
    let parameters: Parameters
    let outputs: Outputs
    let resources: Resources
    let globals: Globals
    let properties: Properties
    let awsTemplateFormatVersion: AWSTemplateFormatVersion = .v2010_09_09
    let metadata: Metadata

    public enum Transform: String, Codable, Sendable {
        case aws_Serverless_2016_10_31 = "AWS::Serverless-2016-10-31"
    }

    public enum AWSTemplateFormatVersion: String, Codable, Sendable {
        case v2010_09_09 = "2010-09-09"
    }

    private enum CodingKeys: String, CodingKey {
        case description = "Description"
        case conditions = "Conditions"
        case transform = "Transform"
        case mappings = "Mappings"
        case parameters = "Parameters"
        case outputs = "Outputs"
        case resources = "Resources"
        case globals = "Globals"
        case properties = "Properties"
        case awsTemplateFormatVersion = "AWSTemplateFormatVersion"
        case metadata = "Metadata"
    }
}
