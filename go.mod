module github.com/panda8z/go-gin-example

go 1.13

require (
	github.com/astaxie/beego v1.12.1
	github.com/denisenkom/go-mssqldb v0.0.0-20200206145737-bbfc9a55622e // indirect
	github.com/dgrijalva/jwt-go v3.2.0+incompatible // indirect
	github.com/erikstmartin/go-testdb v0.0.0-20160219214506-8d10e4a1bae5 // indirect
	github.com/gin-gonic/gin v1.5.0
	github.com/go-ini/ini v1.52.0
	github.com/go-sql-driver/mysql v1.5.0 // indirect
	github.com/jinzhu/gorm v0.0.0-20180213101209-6e1387b44c64
	github.com/jinzhu/inflection v1.0.0 // indirect
	github.com/jinzhu/now v1.1.1 // indirect
	github.com/lib/pq v1.3.0 // indirect
	github.com/mattn/go-sqlite3 v2.0.3+incompatible // indirect
	github.com/unknwon/com v1.0.1
	gopkg.in/ini.v1 v1.52.0 // indirect
)

replace (
	github.com/panda8z/go-gin-example/conf => ./conf
	github.com/panda8z/go-gin-example/middleware => ./middleware
	github.com/panda8z/go-gin-example/models => ./models
	github.com/panda8z/go-gin-example/pkg/e => ./pkg/e
	github.com/panda8z/go-gin-example/pkg/setting => ./pkg/setting
	github.com/panda8z/go-gin-example/pkg/util => ./pkg/util
	github.com/panda8z/go-gin-example/routers => ./routers
	github.com/panda8z/go-gin-example/runtime => ./runtime
)
