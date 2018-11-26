#!/bin/sh

# Compile golang service with dependencies
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
cp main /go/bin/main
#Create image using the scratch dockerfile
#docker build -t gopher:latest -f Dockerfile .
