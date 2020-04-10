FROM golang:1.14.0-alpine

# Install packages needed for compilation
RUN apk add --no-cache gcc musl-dev

ADD . /go/src/github.com/solo-io/solo-plugin-mod
WORKDIR /go/src/github.com/solo-io/solo-plugin-mod

CMD CGO_ENABLED=1 GOARCH=amd64 GOOS=linux go build -x -buildmode=plugin -gcflags="all=-N -l" -o plugin_mod.so plugin.go &> output_mod.txt