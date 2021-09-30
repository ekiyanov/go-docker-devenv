### Compile protobuffers with GRPC

https://github.com/grpc/grpc-go/issues/3794#issuecomment-725860916

	protoc --go_out=. \
		--go-grpc_out=require_unimplemented_servers=false:. \
		./*.proto


### Generate Swagger Spec From Source Code

https://medium.com/@pedram.esmaeeli/generate-swagger-specification-from-go-source-code-648615f7b9d9

	GO111MODULE=off swagger generate spec -o ./swagger.yaml --scan-models
