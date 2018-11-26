# STEP 1 build executable binary
FROM registry.fedoraproject.org/f27/s2i-base:latest

ENV NAME=golang \
    VERSION=1.9 \
    ARCH=x86_64

ENV SUMMARY="Platform for building and running Go $VERSION based applications" \
    DESCRIPTION="Go $VERSION available as container is a base platform for \
building and running various Go $VERSION applications and frameworks. \
Go is an easy to learn, powerful, statically typed language in the C/C++ \
tradition with garbage collection, concurrent programming support, and memory safety features."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Go $VERSION" \
      io.openshift.tags="builder,golang,golang18,rh-golang18,go" \
      com.redhat.component="$NAME" \
      name="$FGC/$NAME" \
      version="$VERSION" \
      architecture="$ARCH" \
      maintainer="Jakub Cajka <jcajka@fedoraproject.org>" \
      usage="docker run $FGC/$NAME"

RUN INSTALL_PKGS="golang" && \
    dnf install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf clean all -y

# Install git
RUN yum update && yum -y install git 
COPY . $GOPATH/src/shyam.dev/hello-gopher/
WORKDIR $GOPATH/src/shyam.dev/hello-gopher/
#get dependancies
#you can also use dep
RUN go get -d -v
#build the binary
RUN $GOPATH/src/shyam.dev/hell-gopher/make.sh
# STEP 2 build a small image
# start from scratch
FROM scratch
# Copy our static executable
COPY --from=builder /go/bin/main /go/bin/main
ENTRYPOINT ["/go/bin/main"]
