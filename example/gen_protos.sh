protoc -I=./server/protos --go_out=./server/protos --go_opt=paths=source_relative \
    --go-grpc_out=./server/protos --go-grpc_opt=paths=source_relative \
    test.proto

protoc --elm_out=./src -I=./server/protos test.proto
