FROM golang:1.14.0-alpine

# Install packages needed for compilation
RUN apk add --no-cache gcc musl-dev

ADD . /go/src/github.com/solo-io/loader-mod
WORKDIR /go/src/github.com/solo-io/loader-mod

RUN CGO_ENABLED=1 GOARCH=amd64 GOOS=linux go build -gcflags="all=-N -l" -o loader-mod main.go

ENTRYPOINT ["/go/src/github.com/solo-io/loader-mod/loader-mod"]