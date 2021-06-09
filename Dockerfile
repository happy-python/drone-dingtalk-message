# build step
FROM golang:1.13 as builder

LABEL maintainer="1091354206@qq.com"

COPY . /build/

WORKDIR /build

RUN go env -w GO111MODULE=on && go env -w GOPROXY=https://goproxy.cn,direct
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build .

# run step
FROM alpine

RUN apk update \
    && apk add --no-cache ca-certificates \
    && rm -rf /var/cache/apk/*

# copy bin from build step
COPY --from=builder /build/drone-dingtalk-message /bin/

ENTRYPOINT ["/bin/drone-dingtalk-message"]