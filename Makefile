all: gw web/bchd.swagger.json

gw: gen/bchd.pb.go gen/bchd.pb.gw.go reverseproxy.go
	go build -o $@ -v

gen/bchd.pb.go: pb/bchd.proto pb/bchd.yaml
	protoc \
		-I/usr/local/include \
		-I./pb \
		-I${GOPATH}/src \
		-I${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
		--go_out=plugins=grpc:gen \
		./pb/bchd.proto

web/bchd.swagger.json: pb/bchd.proto pb/bchd.yaml
	protoc \
		-I/usr/local/include \
		-I./pb \
		-I${GOPATH}/src \
		-I${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
		--swagger_out=logtostderr=true,grpc_api_configuration=./pb/bchd.yaml:web \
		./pb/bchd.proto

gen/bchd.pb.gw.go: pb/bchd.proto pb/bchd.yaml
	protoc \
		-I/usr/local/include \
		-I./pb \
		-I${GOPATH}/src \
		-I${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
		--grpc-gateway_out=logtostderr=true,grpc_api_configuration=./pb/bchd.yaml:gen \
		./pb/bchd.proto
