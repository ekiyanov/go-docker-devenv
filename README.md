# go-vim Docker image
This Docker image adds [Go](https://golang.org/) tools and the following vim plugins to the [official Go image](https://registry.hub.docker.com/_/golang/):

* [vim-go](https://github.com/fatih/vim-go)
* [tagbar](https://github.com/majutsushi/tagbar)
* [neocomplete](https://github.com/Shougo/neocomplete)
* [NERD Tree](https://github.com/scrooloose/nerdtree)
* [vim-airline](https://github.com/bling/vim-airline)
* [fugitive.vim](https://github.com/tpope/vim-fugitive)
* [NERD Tree tabs](https://github.com/jistr/vim-nerdtree-tabs)
* [undotree](https://github.com/mbbill/undotree)
* [vim-easymotion](https://github.com/Lokaltog/vim-easymotion)
* [NERD Commenter](https://github.com/scrooloose/nerdcommenter)

## Usage

Run this image from within your go workspace. You can than edit your project using `vim`, and usual go commands: `go build`, `go run`, etc. 

```
cd your_project
docker run --rm -tiv `pwd`/src:/app -w /app goide
```

## Swagger

https://medium.com/@pedram.esmaeeli/generate-swagger-specification-from-go-source-code-648615f7b9d9

	GO111MODULE=off swagger generate spec -o ./swagger.yaml --scan-models


## GRPC

https://github.com/grpc/grpc-go/issues/3794#issuecomment-725860916

	protoc --go_out=. \
		--go-grpc_out=require_unimplemented_servers=false:. \
		--openapiv2_out=. \
		--grpc-gateway_out=. \
		./*.proto

Google APIs Should be picked up automatically by protoc from following directory. No need to explicitly to be specified

	/usr/local/include/google 


## Debugging

Image has Delve installed, same as plugins for vim. Feel free to

    dlv test -- -test.run=NAME_OF_FUNC
		dlv debug SOURCES.go

or inside vim

    :GoDebugStart
		:GoDebugTest
		:GoDebugTestFunc
