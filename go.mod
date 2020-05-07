module github.com/panda8z/go-gin-example

go 1.13

require (
	github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751
	github.com/astaxie/beego v1.12.1
	github.com/denisenkom/go-mssqldb v0.0.0-20200206145737-bbfc9a55622e // indirect
	github.com/dgrijalva/jwt-go v3.2.0+incompatible
	github.com/erikstmartin/go-testdb v0.0.0-20160219214506-8d10e4a1bae5 // indirect
	github.com/fvbock/endless v0.0.0-20170109170031-447134032cb6
	github.com/gin-gonic/gin v1.6.2
	github.com/go-ini/ini v1.52.0
	github.com/go-openapi/spec v0.19.7 // indirect
	github.com/go-openapi/swag v0.19.8 // indirect
	github.com/go-sql-driver/mysql v1.5.0 // indirect
	github.com/golang/protobuf v1.3.5 // indirect
	github.com/jinzhu/gorm v0.0.0-20180213101209-6e1387b44c64
	github.com/jinzhu/inflection v1.0.0 // indirect
	github.com/jinzhu/now v1.1.1 // indirect
	github.com/lib/pq v1.3.0 // indirect
	github.com/mailru/easyjson v0.7.1 // indirect
	github.com/mattn/go-sqlite3 v2.0.3+incompatible // indirect
	github.com/swaggo/gin-swagger v1.2.0
	github.com/swaggo/swag v1.6.5
	github.com/unknwon/com v1.0.1
	golang.org/x/net v0.0.0-20200324143707-d3edc9973b7e // indirect
	golang.org/x/sys v0.0.0-20200501145240-bc7a7d42d5c3 // indirect
	golang.org/x/tools v0.0.0-20200331202046-9d5940d49312 // indirect
	gopkg.in/ini.v1 v1.52.0 // indirect
)

replace (
	github.com/panda8z/go-gin-example/conf => ./conf
	github.com/panda8z/go-gin-example/docs => ./docs
	github.com/panda8z/go-gin-example/middleware => ./middleware
	github.com/panda8z/go-gin-example/middleware/jwt => ./middleware/jwt
	github.com/panda8z/go-gin-example/models => ./models
	github.com/panda8z/go-gin-example/pkg/e => ./pkg/e
	github.com/panda8z/go-gin-example/pkg/setting => ./pkg/setting
	github.com/panda8z/go-gin-example/pkg/util => ./pkg/util
	github.com/panda8z/go-gin-example/routers => ./routers
	github.com/panda8z/go-gin-example/routers/api => ./routers/api
	github.com/panda8z/go-gin-example/runtime => ./runtime
)
