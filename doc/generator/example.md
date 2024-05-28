INPUT (orange box / input) :
"AWS::Serverless::Function.DeadLetterQueue": {
      "additionalProperties": false,
      "properties": {
        "TargetArn": {
          "type": "string"
        },
        "Type": {
          "type": "string"
        }
      },
      "required": [
        "TargetArn",
        "Type"
      ],
      "type": "object"
    },

1. JSON SCHEMA GENERATOR  - WRITE MANUALLY (the first yellow box) 
struct JSONSChemaForDeadLetterQueue: Decodable {
  let additionalProperties:Bool
  let properties: Properties
  struct Properties : Encodable {
    let key: Type
  }
  struct Type : Encodable {
    let type: String
  }
  let required: [String]
  let type: Type.Object
}

2. GENERATOR TO PRODUCE A SWIFT STRUCT (the second yellow box) 

????


3. OUTPUT OF THE GENERATOR  (Blue box = output)

struct DeadLetterQueue : Encodable {
  let properties: Property
  struct Property : Encodable {
    let taregArn: String
    let Type: String
  }
}

4. I (SEB) will use 3/  to generate YAML / JSON 

YAML/JSON
MyResourceName : 
Properties:
    TargetArn: "abcd"
    Type: "AWS::Serverless::Function.DeadLetterQueue"
