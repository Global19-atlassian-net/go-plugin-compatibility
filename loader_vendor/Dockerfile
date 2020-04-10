FROM golang:1.14.0-alpine

# Install packages needed for compilation
RUN apk add --no-cache gcc musl-dev

ADD . /go/src/github.com/solo-io/loader-vendor
WORKDIR /go/src/github.com/solo-io/loader-vendor

RUN cp -a vendor/. /go/src/ && rm -rf vendor

RUN CGO_ENABLED=1 GOARCH=amd64 GOOS=linux GO111MODULE=off go build -gcflags="all=-N -l" -o loader-vendor main.go

ENTRYPOINT ["/go/src/github.com/solo-io/loader-vendor/loader-vendor"]