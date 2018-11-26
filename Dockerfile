# STEP 1 build executable binary
FROM golang:1.8 as builder
# Install git
RUN apk update && apk add git 
COPY . $GOPATH/src/shyam.dev/hello-gopher/
WORKDIR $GOPATH/src/shyam.dev/hello-gopher/
#get dependancies
#you can also use dep
RUN go get -d -v
#build the binary
RUN go build -o /go/bin/hello
# STEP 2 build a small image
# start from scratch
FROM scratch
# Copy our static executable
COPY --from=builder /go/bin/main /go/bin/main
ENTRYPOINT ["/go/bin/main"]
