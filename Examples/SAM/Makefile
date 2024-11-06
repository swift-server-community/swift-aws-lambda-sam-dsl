common:
	export LAMBDA_USE_LOCAL_DEPS=true

build: common
	swift build #--skip-update

update:  common
	swift package update

testlambda: common
	swift test

test:
	(cd ../.. && swift test --filter AWSLambdaDeploymentDescriptor)

release: common
	swift build -c release

archive: build
	swift package archive --allow-network-connections docker --verbose

deploy: build
	swift package deploy --configuration debug --force --verbose --allow-writing-to-package-directory

nodeploy: build
	mkdir -p .build/plugins/AWSLambdaPackager/outputs/AWSLambdaPackager/SQSLambda
	touch .build/plugins/AWSLambdaPackager/outputs/AWSLambdaPackager/SQSLambda/SQSLambda.zip
	mkdir -p .build/plugins/AWSLambdaPackager/outputs/AWSLambdaPackager/HttpApiLambda
	touch .build/plugins/AWSLambdaPackager/outputs/AWSLambdaPackager/HttpApiLambda/HttpApiLambda.zip
	mkdir -p .build/plugins/AWSLambdaPackager/outputs/AWSLambdaPackager/UrlLambda
	touch .build/plugins/AWSLambdaPackager/outputs/AWSLambdaPackager/UrlLambda/UrlLambda.zip   
	swift package deploy --allow-writing-to-package-directory --configuration debug --nodeploy --nolist --force --verbose 

localtest:
	sam local invoke -t sam.yaml -e Tests/LambdaTests/data/apiv2.json HttpApiLambda 

list: 
	sam list endpoints -t sam.yaml --stack-name swift-aws-lambda-runtime-example --output json

logs:
	sam logs --stack-name swift-aws-lambda-runtime-example  

logstail:
	sam logs --stack-name swift-aws-lambda-runtime-example -t 

delete:
	sam delete --stack-name swift-aws-lambda-runtime-example 
	
clean:
	# find ../.. -name .build -exec rm -rf {} \;
	# find ../.. -name .swiftpm -exec rm -rf {} \;
	# find ../.. -name dist -exec rm -rf {} \;
	rm -rf ../../.build 
	rm -rf .build

build-dd:
	swift build -c debug --product AWSLambdaDeploymentDescriptor

test-generate: build-dd
	/usr/bin/swift \
		-L.build/debug  \
		-I.build/debug/Modules \
		-lAWSLambdaDeploymentDescriptor -Xlinker -v \
		./Deploy.swift

# https://download.swift.org/swift-6.0.2-release/xcode/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE-osx.pkg
# https://download.swift.org/swift-5.10.1-release/xcode/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-osx.pkg