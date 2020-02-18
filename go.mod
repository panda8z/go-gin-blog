module github.com/panda8z/go-gin-example

go 1.13

require (
	github.com/gin-gonic/gin v1.5.0
	github.com/go-ini/ini v1.52.0
	github.com/unknwon/com v1.0.1
)

replace (
	github.com/判da'z/go-gin-example/conf => ./conf
	github.com/panda8z/go-gin-example/middleware => ./middleware
	github.com/panda8z/go-gin-example/models => ./models
	github.com/panda8z/go-gin-example/pkg/setting => ./pkg/setting
	github.com/panda8z/go-gin-example/routers => ./routers
	github.com/panda8z/go-gin-example/runtime => ./runtime
	github.com/panda8z/go-gin-example/util => ./util
)
