cd pb/

protoc -I . --gofast_out=.././go/ ./*.proto ./*/*.proto

cd .././go

go install