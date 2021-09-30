### Compile protobuffers with GRPC

https://github.com/grpc/grpc-go/issues/3794#issuecomment-725860916

	protoc --go_out=. \
		--go-grpc_out=require_unimplemented_servers=false:. \
		--openapiv2_out=. \
		--grpc-gateway_out=. \
		./*.proto


### Generate Swagger Spec From Source Code

https://medium.com/@pedram.esmaeeli/generate-swagger-specification-from-go-source-code-648615f7b9d9

	GO111MODULE=off swagger generate spec -o ./swagger.yaml --scan-models


### Google Apis

Should be picked up automatically by protoc from following directory. No need to explicitly to be specified

	/usr/local/include/google 





