FROM golang:latest

ENV GOPROXY https://goproxy.cn,direct
WORKDIR $GOPATH/src/github.com/panda8z/go-gin-blog
COPY . $GOPATH/src/github.com/panda8z/go-gin-blog
RUN go build .

EXPOSE 8000
ENTRYPOINT ["./main"]