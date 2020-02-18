module github.com/panda8z/go-gin-example

go 1.13

require (
	github.com/EDDYCJY/go-gin-example v0.0.0-20191007083155-a98c25f2172a
	github.com/gin-gonic/gin v1.5.0
	github.com/go-ini/ini v1.52.0
	github.com/go-sql-driver/mysql v1.5.0 // indirect
	github.com/jinzhu/gorm v1.9.12
	github.com/unknwon/com v1.0.1
)

replace (
	github.com/panda8z/go-gin-example/conf => ./conf
	github.com/panda8z/go-gin-example/middleware => ./middleware
	github.com/panda8z/go-gin-example/models => ./models
	github.com/panda8z/go-gin-example/pkg/setting => ./pkg/setting
	github.com/panda8z/go-gin-example/routers => ./routers
	github.com/panda8z/go-gin-example/runtime => ./runtime
	github.com/panda8z/go-gin-example/util => ./util
)
