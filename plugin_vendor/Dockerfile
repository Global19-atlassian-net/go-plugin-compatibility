FROM golang:1.14.0-alpine

# Install packages needed for compilation
RUN apk add --no-cache gcc musl-dev

ADD . /go/src/github.com/solo-io/solo-plugin-vendor
WORKDIR /go/src/github.com/solo-io/solo-plugin-vendor

RUN cp -a vendor/. /go/src/ && rm -rf vendor

# Use GOPATH mode
CMD CGO_ENABLED=1 GOARCH=amd64 GOOS=linux GO111MODULE=off go build -x -buildmode=plugin -gcflags="all=-N -l" -o plugin_vendor.so plugin.go &> output_vendor.txt