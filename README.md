# Gin搭建Blog API's （一）

项目地址：https://github.com/panda8z/go-gin-example

## 思考

首先，在一个初始项目开始前，大家都要思考一下

- 程序的文本配置写在代码中，好吗？
- API 的错误码硬编码在程序中，合适吗？
- db句柄谁都去`Open`，没有统一管理，好吗？
- 获取分页等公共参数，谁都自己写一套逻辑，好吗？

显然在较正规的项目中，这些问题的答案都是**不可以**，为了解决这些问题，我们挑选一款读写配置文件的库，目前比较火的有 [viper](https://github.com/spf13/viper)，有兴趣你未来可以简单了解一下，没兴趣的话等以后接触到再说。

但是本系列选用 [go-ini/ini](https://github.com/go-ini/ini) ，它的 [中文文档](https://ini.unknwon.io/)。大家是必须需要要简单阅读它的文档，再接着完成后面的内容。

## 本文目标

- 编写一个简单的API错误码包。
- 完成一个 Demo 示例。
- 讲解 Demo 所涉及的知识点。

## 介绍和初始化项目

### 初始化项目目录

在前一章节中，我们初始化了一个 `go-gin-example` 项目，接下来我们需要继续新增如下目录结构：

```sh
go-gin-example/
├── conf
├── middleware
├── models
├── pkg
├── routers
└── runtime
```

- conf：用于存储配置文件
- middleware：应用中间件
- models：应用数据库模型
- pkg：第三方包
- routers 路由逻辑处理
- runtime：应用运行时数据

### 添加 Go Modules Replace

打开 `go.mod` 文件，新增 `replace` 配置项，如下：

```
module github.com/panda8z/go-gin-example

go 1.13

require (...)

replace (
        github.com/panda8z/go-gin-example/pkg/setting => ~/go-application/go-gin-example/pkg/setting
        github.com/panda8z/go-gin-example/conf          => ~/go-application/go-gin-example/pkg/conf
        github.com/panda8z/go-gin-example/middleware  => ~/go-application/go-gin-example/middleware
        github.com/panda8z/go-gin-example/models       => ~/go-application/go-gin-example/models
        github.com/panda8z/go-gin-example/routers       => ~/go-application/go-gin-example/routers
)
```

可能你会不理解为什么要特意跑来加 `replace` 配置项，首先你要看到我们使用的是完整的外部模块引用路径（`github.com/panda8z/go-gin-example/xxx`），而这个模块还没推送到远程，是没有办法下载下来的，因此需要用 `replace` 将其指定读取本地的模块路径，这样子就可以解决本地模块读取的问题。

**注：后续每新增一个本地应用目录，你都需要主动去 go.mod 文件里新增一条 replace（我不会提醒你），如果你漏了，那么编译时会出现报错，找不到那个模块。**

### 初始项目数据库

新建 `blog` 数据库，编码为`utf8_general_ci`，在 `blog` 数据库下，新建以下表

**1、 标签表**

```
CREATE TABLE `blog_tag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT '' COMMENT '标签名称',
  `created_on` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  `created_by` varchar(100) DEFAULT '' COMMENT '创建人',
  `modified_on` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  `modified_by` varchar(100) DEFAULT '' COMMENT '修改人',
  `deleted_on` int(10) unsigned DEFAULT '0',
  `state` tinyint(3) unsigned DEFAULT '1' COMMENT '状态 0为禁用、1为启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章标签管理';
```

**2、 文章表**

```
CREATE TABLE `blog_article` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` int(10) unsigned DEFAULT '0' COMMENT '标签ID',
  `title` varchar(100) DEFAULT '' COMMENT '文章标题',
  `desc` varchar(255) DEFAULT '' COMMENT '简述',
  `content` text,
  `created_on` int(11) DEFAULT NULL,
  `created_by` varchar(100) DEFAULT '' COMMENT '创建人',
  `modified_on` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  `modified_by` varchar(255) DEFAULT '' COMMENT '修改人',
  `deleted_on` int(10) unsigned DEFAULT '0',
  `state` tinyint(3) unsigned DEFAULT '1' COMMENT '状态 0为禁用1为启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章管理';
```

**3、 认证表**

```
CREATE TABLE `blog_auth` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT '' COMMENT '账号',
  `password` varchar(50) DEFAULT '' COMMENT '密码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `blog`.`blog_auth` (`id`, `username`, `password`) VALUES (null, 'test', 'test123456');
```

## 编写项目配置包

在 `go-gin-example` 应用目录下，拉取 `go-ini/ini` 的依赖包，如下：

```
$ go get -u github.com/go-ini/ini
go: finding github.com/go-ini/ini v1.48.0
go: downloading github.com/go-ini/ini v1.48.0
go: extracting github.com/go-ini/ini v1.48.0
```

接下来我们需要编写基础的应用配置文件，在 `go-gin-example` 的`conf`目录下新建`app.ini`文件，写入内容：

```
#debug or release
RUN_MODE = debug

[app]
PAGE_SIZE = 10
JWT_SECRET = 23347$040412

[server]
HTTP_PORT = 8000
READ_TIMEOUT = 60
WRITE_TIMEOUT = 60

[database]
TYPE = mysql
USER = 数据库账号
PASSWORD = 数据库密码
#127.0.0.1:3306
HOST = 数据库IP:数据库端口号
NAME = blog
TABLE_PREFIX = blog_
```

建立调用配置的`setting`模块，在`go-gin-example`的`pkg`目录下新建`setting`目录（注意新增 replace 配置），新建 `setting.go` 文件，写入内容：

```
package setting

import (
    "log"
    "time"

    "github.com/go-ini/ini"
)

var (
    Cfg *ini.File

    RunMode string

    HTTPPort int
    ReadTimeout time.Duration
    WriteTimeout time.Duration

    PageSize int
    JwtSecret string
)

func init() {
    var err error
    Cfg, err = ini.Load("conf/app.ini")
    if err != nil {
        log.Fatalf("Fail to parse 'conf/app.ini': %v", err)
    }

    LoadBase()
    LoadServer()
    LoadApp()
}

func LoadBase() {
    RunMode = Cfg.Section("").Key("RUN_MODE").MustString("debug")
}

func LoadServer() {
    sec, err := Cfg.GetSection("server")
    if err != nil {
        log.Fatalf("Fail to get section 'server': %v", err)
    }

    HTTPPort = sec.Key("HTTP_PORT").MustInt(8000)
    ReadTimeout = time.Duration(sec.Key("READ_TIMEOUT").MustInt(60)) * time.Second
    WriteTimeout =  time.Duration(sec.Key("WRITE_TIMEOUT").MustInt(60)) * time.Second    
}

func LoadApp() {
    sec, err := Cfg.GetSection("app")
    if err != nil {
        log.Fatalf("Fail to get section 'app': %v", err)
    }

    JwtSecret = sec.Key("JWT_SECRET").MustString("!@)*#)!@U#@*!@!)")
    PageSize = sec.Key("PAGE_SIZE").MustInt(10)
}
```

当前的目录结构：

```
go-gin-example
├── conf
│   └── app.ini
├── go.mod
├── go.sum
├── middleware
├── models
├── pkg
│   └── setting.go
├── routers
└── runtime
```

## 编写API错误码包

建立错误码的`e`模块，在`go-gin-example`的`pkg`目录下新建`e`目录（注意新增 replace 配置），新建`code.go`和`msg.go`文件，写入内容：

**1、 code.go：**

```
package e

const (
    SUCCESS = 200
    ERROR = 500
    INVALID_PARAMS = 400

    ERROR_EXIST_TAG = 10001
    ERROR_NOT_EXIST_TAG = 10002
    ERROR_NOT_EXIST_ARTICLE = 10003

    ERROR_AUTH_CHECK_TOKEN_FAIL = 20001
    ERROR_AUTH_CHECK_TOKEN_TIMEOUT = 20002
    ERROR_AUTH_TOKEN = 20003
    ERROR_AUTH = 20004
)
```

**2、 msg.go：**

```
package e

var MsgFlags = map[int]string {
    SUCCESS : "ok",
    ERROR : "fail",
    INVALID_PARAMS : "请求参数错误",
    ERROR_EXIST_TAG : "已存在该标签名称",
    ERROR_NOT_EXIST_TAG : "该标签不存在",
    ERROR_NOT_EXIST_ARTICLE : "该文章不存在",
    ERROR_AUTH_CHECK_TOKEN_FAIL : "Token鉴权失败",
    ERROR_AUTH_CHECK_TOKEN_TIMEOUT : "Token已超时",
    ERROR_AUTH_TOKEN : "Token生成失败",
    ERROR_AUTH : "Token错误",
}

func GetMsg(code int) string {
    msg, ok := MsgFlags[code]
    if ok {
        return msg
    }

    return MsgFlags[ERROR]
}
```

## 编写工具包

在`go-gin-example`的`pkg`目录下新建`util`目录（注意新增 replace 配置），并拉取`com`的依赖包，如下：

```
go get -u github.com/unknwon/com
```

### 编写分页页码的获取方法

在`util`目录下新建`pagination.go`，写入内容：

```
package util

import (
    "github.com/gin-gonic/gin"
    "github.com/unknwon/com"

    "github.com/panda8z/go-gin-example/pkg/setting"
)

func GetPage(c *gin.Context) int {
    result := 0
    page, _ := com.StrTo(c.Query("page")).Int()
    if page > 0 {
        result = (page - 1) * setting.PageSize
    }

    return result
}
```

## 编写models init

拉取`gorm`的依赖包，如下：

```
go get -u github.com/jinzhu/gorm
```

拉取`mysql`驱动的依赖包，如下：

```
go get -u github.com/go-sql-driver/mysql
```

完成后，在`go-gin-example`的`models`目录下新建`models.go`，用于`models`的初始化使用

```
package models

import (
    "log"
    "fmt"

    "github.com/jinzhu/gorm"
    _ "github.com/jinzhu/gorm/dialects/mysql"

    "github.com/panda8z/go-gin-example/pkg/setting"
)

var db *gorm.DB

type Model struct {
    ID int `gorm:"primary_key" json:"id"`
    CreatedOn int `json:"created_on"`
    ModifiedOn int `json:"modified_on"`
}

func init() {
    var (
        err error
        dbType, dbName, user, password, host, tablePrefix string
    )

    sec, err := setting.Cfg.GetSection("database")
    if err != nil {
        log.Fatal(2, "Fail to get section 'database': %v", err)
    }

    dbType = sec.Key("TYPE").String()
    dbName = sec.Key("NAME").String()
    user = sec.Key("USER").String()
    password = sec.Key("PASSWORD").String()
    host = sec.Key("HOST").String()
    tablePrefix = sec.Key("TABLE_PREFIX").String()

    db, err = gorm.Open(dbType, fmt.Sprintf("%s:%s@tcp(%s)/%s?charset=utf8&parseTime=True&loc=Local", 
        user, 
        password, 
        host, 
        dbName))

    if err != nil {
        log.Println(err)
    }

    gorm.DefaultTableNameHandler = func (db *gorm.DB, defaultTableName string) string  {
        return tablePrefix + defaultTableName;
    }

    db.SingularTable(true)
    db.LogMode(true)
    db.DB().SetMaxIdleConns(10)
    db.DB().SetMaxOpenConns(100)
}

func CloseDB() {
    defer db.Close()
}
```

## 编写项目启动、路由文件

最基础的准备工作完成啦，让我们开始编写Demo吧！

### 编写Demo

在`go-gin-example`下建立`main.go`作为启动文件（也就是`main`包），我们先写个**Demo**，帮助大家理解，写入文件内容：

```
package main

import (
    "fmt"
      "net/http"

    "github.com/gin-gonic/gin"

      "github.com/panda8z/go-gin-example/pkg/setting"
)

func main() {
    router := gin.Default()
    router.GET("/test", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "message": "test",
        })
    })

    s := &http.Server{
        Addr:           fmt.Sprintf(":%d", setting.HTTPPort),
        Handler:        router,
        ReadTimeout:    setting.ReadTimeout,
        WriteTimeout:   setting.WriteTimeout,
        MaxHeaderBytes: 1 << 20,
    }

    s.ListenAndServe()
}
```

执行`go run main.go`，查看命令行是否显示

```
[GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.

[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:    export GIN_MODE=release
 - using code:    gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /test                     --> main.main.func1 (3 handlers)
```

在本机执行`curl 127.0.0.1:8000/test`，检查是否返回`{"message":"test"}`。

### 知识点

**那么，我们来延伸一下Demo所涉及的知识点！**

##### 标准库

- [fmt](https://golang.org/pkg/fmt/)：实现了类似C语言printf和scanf的格式化I/O。格式化动作（'verb'）源自C语言但更简单
- [net/http](https://golang.org/pkg/net/http/)：提供了HTTP客户端和服务端的实现

##### **Gin**

- [gin.Default()](https://gowalker.org/github.com/gin-gonic/gin#Default)：返回Gin的`type Engine struct{...}`，里面包含`RouterGroup`，相当于创建一个路由`Handlers`，可以后期绑定各类的路由规则和函数、中间件等
- [router.GET(...){...}](https://gowalker.org/github.com/gin-gonic/gin#IRoutes)：创建不同的HTTP方法绑定到`Handlers`中，也支持POST、PUT、DELETE、PATCH、OPTIONS、HEAD 等常用的Restful方法
- [gin.H{...}](https://gowalker.org/github.com/gin-gonic/gin#H)：就是一个`map[string]interface{}`
- [gin.Context](https://gowalker.org/github.com/gin-gonic/gin#Context)：`Context`是`gin`中的上下文，它允许我们在中间件之间传递变量、管理流、验证JSON请求、响应JSON请求等，在`gin`中包含大量`Context`的方法，例如我们常用的`DefaultQuery`、`Query`、`DefaultPostForm`、`PostForm`等等

##### &http.Server 和 ListenAndServe？

1、http.Server：

```
type Server struct {
    Addr    string
    Handler Handler
    TLSConfig *tls.Config
    ReadTimeout time.Duration
    ReadHeaderTimeout time.Duration
    WriteTimeout time.Duration
    IdleTimeout time.Duration
    MaxHeaderBytes int
    ConnState func(net.Conn, ConnState)
    ErrorLog *log.Logger
}
```

- Addr：监听的TCP地址，格式为`:8000`
- Handler：http句柄，实质为`ServeHTTP`，用于处理程序响应HTTP请求
- TLSConfig：安全传输层协议（TLS）的配置
- ReadTimeout：允许读取的最大时间
- ReadHeaderTimeout：允许读取请求头的最大时间
- WriteTimeout：允许写入的最大时间
- IdleTimeout：等待的最大时间
- MaxHeaderBytes：请求头的最大字节数
- ConnState：指定一个可选的回调函数，当客户端连接发生变化时调用
- ErrorLog：指定一个可选的日志记录器，用于接收程序的意外行为和底层系统错误；如果未设置或为`nil`则默认以日志包的标准日志记录器完成（也就是在控制台输出）

2、 ListenAndServe：

```
func (srv *Server) ListenAndServe() error {
    addr := srv.Addr
    if addr == "" {
        addr = ":http"
    }
    ln, err := net.Listen("tcp", addr)
    if err != nil {
        return err
    }
    return srv.Serve(tcpKeepAliveListener{ln.(*net.TCPListener)})
}
```

开始监听服务，监听TCP网络地址，Addr和调用应用程序处理连接上的请求。

我们在源码中看到`Addr`是调用我们在`&http.Server`中设置的参数，因此我们在设置时要用`&`，我们要改变参数的值，因为我们`ListenAndServe`和其他一些方法需要用到`&http.Server`中的参数，他们是相互影响的。

3、 `http.ListenAndServe`和 [连载一](https://segmentfault.com/a/1190000013297625#articleHeader5) 的`r.Run()`有区别吗？

我们看看`r.Run`的实现：

```
func (engine *Engine) Run(addr ...string) (err error) {
    defer func() { debugPrintError(err) }()

    address := resolveAddress(addr)
    debugPrint("Listening and serving HTTP on %s\n", address)
    err = http.ListenAndServe(address, engine)
    return
}
```

通过分析源码，得知**本质上没有区别**，同时也得知了启动`gin`时的监听debug信息在这里输出。

4、 为什么Demo里会有`WARNING`？

首先我们可以看下`Default()`的实现

```
// Default returns an Engine instance with the Logger and Recovery middleware already attached.
func Default() *Engine {
    debugPrintWARNINGDefault()
    engine := New()
    engine.Use(Logger(), Recovery())
    return engine
}
```

大家可以看到默认情况下，已经附加了日志、恢复中间件的引擎实例。并且在开头调用了`debugPrintWARNINGDefault()`，而它的实现就是输出该行日志

```
func debugPrintWARNINGDefault() {
    debugPrint(`[WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.
`)
}
```

而另外一个`Running in "debug" mode. Switch to "release" mode in production.`，是运行模式原因，并不难理解，已在配置文件的管控下 :-)，运维人员随时就可以修改它的配置。

5、 Demo的`router.GET`等路由规则可以不写在`main`包中吗？

我们发现`router.GET`等路由规则，在Demo中被编写在了`main`包中，感觉很奇怪，我们去抽离这部分逻辑！

在`go-gin-example`下`routers`目录新建`router.go`文件，写入内容：

```
package routers

import (
    "github.com/gin-gonic/gin"

    "github.com/panda8z/go-gin-example/pkg/setting"
)

func InitRouter() *gin.Engine {
    r := gin.New()

    r.Use(gin.Logger())

    r.Use(gin.Recovery())

    gin.SetMode(setting.RunMode)

    r.GET("/test", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "message": "test",
        })
    })

    return r
}
```

修改`main.go`的文件内容：

```
package main

import (
    "fmt"
    "net/http"

    "github.com/panda8z/go-gin-example/routers"
    "github.com/panda8z/go-gin-example/pkg/setting"
)

func main() {
    router := routers.InitRouter()

    s := &http.Server{
        Addr:           fmt.Sprintf(":%d", setting.HTTPPort),
        Handler:        router,
        ReadTimeout:    setting.ReadTimeout,
        WriteTimeout:   setting.WriteTimeout,
        MaxHeaderBytes: 1 << 20,
    }

    s.ListenAndServe()
}
```

当前目录结构：

```
go-gin-example/
├── conf
│   └── app.ini
├── main.go
├── middleware
├── models
│   └── models.go
├── pkg
│   ├── e
│   │   ├── code.go
│   │   └── msg.go
│   ├── setting
│   │   └── setting.go
│   └── util
│       └── pagination.go
├── routers
│   └── router.go
├── runtime
```

重启服务，执行 `curl 127.0.0.1:8000/test`查看是否正确返回。

下一节，我们将以我们的 Demo 为起点进行修改，开始编码！

## 参考

### 本系列示例代码

- [go-gin-example](https://github.com/panda8z/go-gin-example)

## 关于

### 修改记录

- 第一版：2018年02月16日发布文章
- 第二版：2019年10月01日修改文章



# Gin搭建Blog API's （二）

项目地址：https://github.com/EDDYCJY/go-gin-example

## 涉及知识点

- [Gin](https://github.com/gin-gonic/gin)：Golang的一个微框架，性能极佳。
- [beego-validation](https://github.com/astaxie/beego/tree/master/validation)：本节采用的beego的表单验证库，[中文文档](https://beego.me/docs/mvc/controller/validation.md)。
- [gorm](https://github.com/jinzhu/gorm)，对开发人员友好的ORM框架，[英文文档](http://gorm.io/docs/)
- [com](https://github.com/Unknwon/com)，一个小而美的工具包。

## 本文目标

- 完成博客的标签类接口定义和编写

## 定义接口

本节正是编写标签的逻辑，我们想一想，一般接口为增删改查是基础的，那么我们定义一下接口吧！

- 获取标签列表：GET("/tags")
- 新建标签：POST("/tags")
- 编辑指定标签：PUT("/tags/:id")
- 删除指定标签：DELETE("/tags/:id")

------

## 编写路由空壳

开始编写路由文件逻辑，在`routers`下新建`api`目录，我们当前是第一个API大版本，因此在`api`下新建`v1`目录，再新建`tag.go`文件，写入内容：

```
package v1

import (
    "github.com/gin-gonic/gin"
)

//获取多个文章标签
func GetTags(c *gin.Context) {
}

//新增文章标签
func AddTag(c *gin.Context) {
}

//修改文章标签
func EditTag(c *gin.Context) {
}

//删除文章标签
func DeleteTag(c *gin.Context) {
}
```

## 注册路由

我们打开`routers`下的`router.go`文件，修改文件内容为：

```
package routers

import (
    "github.com/gin-gonic/gin"

    "gin-blog/routers/api/v1"
    "gin-blog/pkg/setting"
)

func InitRouter() *gin.Engine {
    r := gin.New()

    r.Use(gin.Logger())

    r.Use(gin.Recovery())

    gin.SetMode(setting.RunMode)

    apiv1 := r.Group("/api/v1")
    {
        //获取标签列表
        apiv1.GET("/tags", v1.GetTags)
        //新建标签
        apiv1.POST("/tags", v1.AddTag)
        //编辑指定标签
        apiv1.PUT("/tags/:id", v1.EditTag)
        //删除指定标签
        apiv1.DELETE("/tags/:id", v1.DeleteTag)
    }

    return r
}
```

当前目录结构：

```
gin-blog/
├── conf
│   └── app.ini
├── main.go
├── middleware
├── models
│   └── models.go
├── pkg
│   ├── e
│   │   ├── code.go
│   │   └── msg.go
│   ├── setting
│   │   └── setting.go
│   └── util
│       └── pagination.go
├── routers
│   ├── api
│   │   └── v1
│   │       └── tag.go
│   └── router.go
├── runtime
```

## 检验路由是否注册成功

回到命令行，执行`go run main.go`，检查路由规则是否注册成功。

```
$ go run main.go 
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:    export GIN_MODE=release
 - using code:    gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /api/v1/tags              --> gin-blog/routers/api/v1.GetTags (3 handlers)
[GIN-debug] POST   /api/v1/tags              --> gin-blog/routers/api/v1.AddTag (3 handlers)
[GIN-debug] PUT    /api/v1/tags/:id          --> gin-blog/routers/api/v1.EditTag (3 handlers)
[GIN-debug] DELETE /api/v1/tags/:id          --> gin-blog/routers/api/v1.DeleteTag (3 handlers)
```

运行成功，那么我们愉快的**开始编写我们的接口**吧！

## 下载依赖包

------

首先我们要拉取`validation`的依赖包，在后面的接口里会使用到表单验证

```
go get -u github.com/astaxie/beego/validation
```

## 编写标签列表的models逻辑

创建`models`目录下的`tag.go`，写入文件内容：

```
package models

type Tag struct {
    Model

    Name string `json:"name"`
    CreatedBy string `json:"created_by"`
    ModifiedBy string `json:"modified_by"`
    State int `json:"state"`
}

func GetTags(pageNum int, pageSize int, maps interface {}) (tags []Tag) {
    db.Where(maps).Offset(pageNum).Limit(pageSize).Find(&tags)

    return
}

func GetTagTotal(maps interface {}) (count int){
    db.Model(&Tag{}).Where(maps).Count(&count)

    return
}
```

1. 我们创建了一个`Tag struct{}`，用于`Gorm`的使用。并给予了附属属性`json`，这样子在`c.JSON`的时候就会自动转换格式，非常的便利
2. 可能会有的初学者看到`return`，而后面没有跟着变量，会不理解；其实你可以看到在函数末端，我们已经显示声明了返回值，这个变量在函数体内也可以直接使用，因为他在一开始就被声明了
3. 有人会疑惑`db`是哪里来的；因为在同个`models`包下，因此`db *gorm.DB`是可以直接使用的

## 编写标签列表的路由逻辑

打开`routers`目录下v1版本的`tag.go`，第一我们先编写**获取标签列表的接口**

修改文件内容：

```
package v1

import (
    "net/http"

    "github.com/gin-gonic/gin"
    //"github.com/astaxie/beego/validation"
    "github.com/Unknwon/com"

    "gin-blog/pkg/e"
    "gin-blog/models"
    "gin-blog/pkg/util"
    "gin-blog/pkg/setting"
)

//获取多个文章标签
func GetTags(c *gin.Context) {
    name := c.Query("name")

    maps := make(map[string]interface{})
    data := make(map[string]interface{})

    if name != "" {
        maps["name"] = name
    }

    var state int = -1
    if arg := c.Query("state"); arg != "" {
        state = com.StrTo(arg).MustInt()
        maps["state"] = state
    }

    code := e.SUCCESS

    data["lists"] = models.GetTags(util.GetPage(c), setting.PageSize, maps)
    data["total"] = models.GetTagTotal(maps)

    c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : data,
    })
}

//新增文章标签
func AddTag(c *gin.Context) {
}

//修改文章标签
func EditTag(c *gin.Context) {
}

//删除文章标签
func DeleteTag(c *gin.Context) {
}
```

1. `c.Query`可用于获取`?name=test&state=1`这类URL参数，而`c.DefaultQuery`则支持设置一个默认值
2. `code`变量使用了`e`模块的错误编码，这正是先前规划好的错误码，方便排错和识别记录
3. `util.GetPage`保证了各接口的`page`处理是一致的
4. `c *gin.Context`是`Gin`很重要的组成部分，可以理解为上下文，它允许我们在中间件之间传递变量、管理流、验证请求的JSON和呈现JSON响应

在本机执行`curl 127.0.0.1:8000/api/v1/tags`，正确的返回值为`{"code":200,"data":{"lists":[],"total":0},"msg":"ok"}`，若存在问题请结合gin结果进行拍错。

在获取标签列表接口中，我们可以根据`name`、`state`、`page`来筛选查询条件，分页的步长可通过`app.ini`进行配置，以`lists`、`total`的组合返回达到分页效果。

## 编写新增标签的models逻辑

接下来我们编写**新增标签**的接口

打开`models`目录下的`tag.go`，修改文件（增加2个方法）：

```
...
func ExistTagByName(name string) bool {
    var tag Tag
    db.Select("id").Where("name = ?", name).First(&tag)
    if tag.ID > 0 {
        return true
    }

    return false
}

func AddTag(name string, state int, createdBy string) bool{
    db.Create(&Tag {
        Name : name,
        State : state,
        CreatedBy : createdBy,
    })

    return true
}
...
```

## 编写新增标签的路由逻辑

打开`routers`目录下的`tag.go`，修改文件（变动AddTag方法）：

```
package v1

import (
    "log"
    "net/http"

    "github.com/gin-gonic/gin"
    "github.com/astaxie/beego/validation"
    "github.com/Unknwon/com"

    "gin-blog/pkg/e"
    "gin-blog/models"
    "gin-blog/pkg/util"
    "gin-blog/pkg/setting"
)
...
//新增文章标签
func AddTag(c *gin.Context) {
    name := c.Query("name")
    state := com.StrTo(c.DefaultQuery("state", "0")).MustInt()
    createdBy := c.Query("created_by")

    valid := validation.Validation{}
    valid.Required(name, "name").Message("名称不能为空")
    valid.MaxSize(name, 100, "name").Message("名称最长为100字符")
    valid.Required(createdBy, "created_by").Message("创建人不能为空")
    valid.MaxSize(createdBy, 100, "created_by").Message("创建人最长为100字符")
    valid.Range(state, 0, 1, "state").Message("状态只允许0或1")

    code := e.INVALID_PARAMS
    if ! valid.HasErrors() {
        if ! models.ExistTagByName(name) {
            code = e.SUCCESS
            models.AddTag(name, state, createdBy)
        } else {
            code = e.ERROR_EXIST_TAG
        }
    }

    c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : make(map[string]string),
    })
}
...
```

用`Postman`用POST访问`http://127.0.0.1:8000/api/v1/tags?name=1&state=1&created_by=test`，查看`code`是否返回`200`及`blog_tag`表中是否有值，有值则正确。

## 编写models callbacks

但是这个时候大家会发现，我明明新增了标签，但`created_on`居然没有值，那做修改标签的时候`modified_on`会不会也存在这个问题？

为了解决这个问题，我们需要打开`models`目录下的`tag.go`文件，修改文件内容（修改包引用和增加2个方法）：

```
package models

import (
    "time"

    "github.com/jinzhu/gorm"
)

...

func (tag *Tag) BeforeCreate(scope *gorm.Scope) error {
    scope.SetColumn("CreatedOn", time.Now().Unix())

    return nil
}

func (tag *Tag) BeforeUpdate(scope *gorm.Scope) error {
    scope.SetColumn("ModifiedOn", time.Now().Unix())

    return nil
}
```

重启服务，再在用`Postman`用POST访问`http://127.0.0.1:8000/api/v1/tags?name=2&state=1&created_by=test`，发现`created_on`已经有值了！

**在这几段代码中，涉及到知识点：**

这属于`gorm`的`Callbacks`，可以将回调方法定义为模型结构的指针，在创建、更新、查询、删除时将被调用，如果任何回调返回错误，gorm将停止未来操作并回滚所有更改。

`gorm`所支持的回调方法：

- 创建：BeforeSave、BeforeCreate、AfterCreate、AfterSave
- 更新：BeforeSave、BeforeUpdate、AfterUpdate、AfterSave
- 删除：BeforeDelete、AfterDelete
- 查询：AfterFind

------

## 编写其余接口的路由逻辑

接下来，我们一口气把剩余的两个接口（EditTag、DeleteTag）完成吧

打开`routers`目录下v1版本的`tag.go`文件，修改内容：

```
...
//修改文章标签
func EditTag(c *gin.Context) {
    id := com.StrTo(c.Param("id")).MustInt()
    name := c.Query("name")
    modifiedBy := c.Query("modified_by")

    valid := validation.Validation{}

    var state int = -1
    if arg := c.Query("state"); arg != "" {
        state = com.StrTo(arg).MustInt()
        valid.Range(state, 0, 1, "state").Message("状态只允许0或1")
    }

    valid.Required(id, "id").Message("ID不能为空")
    valid.Required(modifiedBy, "modified_by").Message("修改人不能为空")
    valid.MaxSize(modifiedBy, 100, "modified_by").Message("修改人最长为100字符")
    valid.MaxSize(name, 100, "name").Message("名称最长为100字符")

    code := e.INVALID_PARAMS
    if ! valid.HasErrors() {
        code = e.SUCCESS
        if models.ExistTagByID(id) {
            data := make(map[string]interface{})
            data["modified_by"] = modifiedBy
            if name != "" {
                data["name"] = name
            }
            if state != -1 {
                data["state"] = state
            }

            models.EditTag(id, data)
        } else {
            code = e.ERROR_NOT_EXIST_TAG
        }
    }

    c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : make(map[string]string),
    })
}    

//删除文章标签
func DeleteTag(c *gin.Context) {
    id := com.StrTo(c.Param("id")).MustInt()

    valid := validation.Validation{}
    valid.Min(id, 1, "id").Message("ID必须大于0")

    code := e.INVALID_PARAMS
    if ! valid.HasErrors() {
        code = e.SUCCESS
        if models.ExistTagByID(id) {
            models.DeleteTag(id)
        } else {
            code = e.ERROR_NOT_EXIST_TAG
        }
    }

    c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : make(map[string]string),
    })
}
```

## 编写其余接口的models逻辑

打开`models`下的`tag.go`，修改文件内容：

```
...

func ExistTagByID(id int) bool {
    var tag Tag
    db.Select("id").Where("id = ?", id).First(&tag)
    if tag.ID > 0 {
        return true
    }

    return false
}

func DeleteTag(id int) bool {
    db.Where("id = ?", id).Delete(&Tag{})

    return true
}

func EditTag(id int, data interface {}) bool {
    db.Model(&Tag{}).Where("id = ?", id).Updates(data)

    return true
}
...
```

## 验证功能

重启服务，用Postman

- PUT访问http://127.0.0.1:8000/api/v1/tags/1?name=edit1&state=0&modified_by=edit1，查看code是否返回200
- DELETE访问http://127.0.0.1:8000/api/v1/tags/1，查看code是否返回200

至此，Tag的API's完成，下一节我们将开始Article的API's编写！

## 参考

### 本系列示例代码

- [go-gin-example](https://github.com/EDDYCJY/go-gin-example)

## 关于

### 修改记录

- 第一版：2018年02月16日发布文章
- 第二版：2019年10月01日修改文章





# Gin搭建Blog API's （三）

## 涉及知识点

- [Gin](https://github.com/gin-gonic/gin)：Golang 的一个微框架，性能极佳。
- [beego-validation](https://github.com/astaxie/beego/tree/master/validation)：本节采用的 beego 的表单验证库，[中文文档](https://beego.me/docs/mvc/controller/validation.md)。
- [gorm](https://github.com/jinzhu/gorm)，对开发人员友好的 ORM 框架，[英文文档](http://gorm.io/docs/)
- [com](https://github.com/Unknwon/com)，一个小而美的工具包。

## 本文目标

- 完成博客的文章类接口定义和编写

## 定义接口

本节编写文章的逻辑，我们定义一下接口吧！

- 获取文章列表：GET("/articles”)
- 获取指定文章：POST("/articles/:id”)
- 新建文章：POST("/articles”)
- 更新指定文章：PUT("/articles/:id”)
- 删除指定文章：DELETE("/articles/:id”)

## 编写路由逻辑

在`routers`的 v1 版本下，新建`article.go`文件，写入内容：

```go
package v1

import (
    "github.com/gin-gonic/gin"
)

//获取单个文章
func GetArticle(c *gin.Context) {
}

//获取多个文章
func GetArticles(c *gin.Context) {
}

//新增文章
func AddArticle(c *gin.Context) {
}

//修改文章
func EditArticle(c *gin.Context) {
}

//删除文章
func DeleteArticle(c *gin.Context) {
}
```

我们打开`routers`下的`router.go`文件，修改文件内容为：

```go
package routers

import (
    "github.com/gin-gonic/gin"

    "github.com/EDDYCJY/go-gin-example/routers/api/v1"
    "github.com/EDDYCJY/go-gin-example/pkg/setting"
)

func InitRouter() *gin.Engine {
    ...
    apiv1 := r.Group("/api/v1")
    {
        ...
        //获取文章列表
        apiv1.GET("/articles", v1.GetArticles)
        //获取指定文章
        apiv1.GET("/articles/:id", v1.GetArticle)
        //新建文章
        apiv1.POST("/articles", v1.AddArticle)
        //更新指定文章
        apiv1.PUT("/articles/:id", v1.EditArticle)
        //删除指定文章
        apiv1.DELETE("/articles/:id", v1.DeleteArticle)
    }

    return r
}
```

当前目录结构：

```
go-gin-example/
├── conf
│   └── app.ini
├── main.go
├── middleware
├── models
│   ├── models.go
│   └── tag.go
├── pkg
│   ├── e
│   │   ├── code.go
│   │   └── msg.go
│   ├── setting
│   │   └── setting.go
│   └── util
│       └── pagination.go
├── routers
│   ├── api
│   │   └── v1
│   │       ├── article.go
│   │       └── tag.go
│   └── router.go
├── runtime
```

在基础的路由规则配置结束后，我们**开始编写我们的接口**吧！

------

\##编写 models 逻辑 创建`models`目录下的`article.go`，写入文件内容：

```go
package models

import (
    "github.com/jinzhu/gorm"

    "time"
)

type Article struct {
    Model

    TagID int `json:"tag_id" gorm:"index"`
    Tag   Tag `json:"tag"`

    Title string `json:"title"`
    Desc string `json:"desc"`
    Content string `json:"content"`
    CreatedBy string `json:"created_by"`
    ModifiedBy string `json:"modified_by"`
    State int `json:"state"`
}


func (article *Article) BeforeCreate(scope *gorm.Scope) error {
    scope.SetColumn("CreatedOn", time.Now().Unix())

    return nil
}

func (article *Article) BeforeUpdate(scope *gorm.Scope) error {
    scope.SetColumn("ModifiedOn", time.Now().Unix())

    return nil
}
```

我们创建了一个`Article struct {}`，与`Tag`不同的是，`Article`多了几项，如下：

1. `gorm:index`，用于声明这个字段为索引，如果你使用了自动迁移功能则会有所影响，在不使用则无影响
2. `Tag`字段，实际是一个嵌套的`struct`，它利用`TagID`与`Tag`模型相互关联，在执行查询的时候，能够达到`Article`、`Tag`关联查询的功能
3. `time.Now().Unix()` 返回当前的时间戳

接下来，请确保已对上一章节的内容通读且了解，由于逻辑偏差不会太远，我们本节直接编写这五个接口

------

打开`models`目录下的`article.go`，修改文件内容：

```go
package models

import (
    "time"

    "github.com/jinzhu/gorm"
)

type Article struct {
    Model

    TagID int `json:"tag_id" gorm:"index"`
    Tag   Tag `json:"tag"`

    Title string `json:"title"`
    Desc string `json:"desc"`
    Content string `json:"content"`
    CreatedBy string `json:"created_by"`
    ModifiedBy string `json:"modified_by"`
    State int `json:"state"`
}


func ExistArticleByID(id int) bool {
    var article Article
    db.Select("id").Where("id = ?", id).First(&article)

    if article.ID > 0 {
        return true
    }

    return false
}

func GetArticleTotal(maps interface {}) (count int){
    db.Model(&Article{}).Where(maps).Count(&count)

    return
}

func GetArticles(pageNum int, pageSize int, maps interface {}) (articles []Article) {
    db.Preload("Tag").Where(maps).Offset(pageNum).Limit(pageSize).Find(&articles)

    return
}

func GetArticle(id int) (article Article) {
    db.Where("id = ?", id).First(&article)
    db.Model(&article).Related(&article.Tag)

    return
}

func EditArticle(id int, data interface {}) bool {
    db.Model(&Article{}).Where("id = ?", id).Updates(data)

    return true
}

func AddArticle(data map[string]interface {}) bool {
    db.Create(&Article {
        TagID : data["tag_id"].(int),
        Title : data["title"].(string),
        Desc : data["desc"].(string),
        Content : data["content"].(string),
        CreatedBy : data["created_by"].(string),
        State : data["state"].(int),
    })

    return true
}

func DeleteArticle(id int) bool {
    db.Where("id = ?", id).Delete(Article{})

    return true
}

func (article *Article) BeforeCreate(scope *gorm.Scope) error {
    scope.SetColumn("CreatedOn", time.Now().Unix())

    return nil
}

func (article *Article) BeforeUpdate(scope *gorm.Scope) error {
    scope.SetColumn("ModifiedOn", time.Now().Unix())

    return nil
}
```

在这里，我们拿出三点不同来讲，如下：

**1、 我们的`Article`是如何关联到`Tag`？**

```go
func GetArticle(id int) (article Article) {
    db.Where("id = ?", id).First(&article)
    db.Model(&article).Related(&article.Tag)

    return
}
```

能够达到关联，首先是`gorm`本身做了大量的约定俗成

- `Article`有一个结构体成员是`TagID`，就是外键。`gorm`会通过类名+ID 的方式去找到这两个类之间的关联关系
- `Article`有一个结构体成员是`Tag`，就是我们嵌套在`Article`里的`Tag`结构体，我们可以通过`Related`进行关联查询

**2、 `Preload`是什么东西，为什么查询可以得出每一项的关联`Tag`？**

```go
func GetArticles(pageNum int, pageSize int, maps interface {}) (articles []Article) {
    db.Preload("Tag").Where(maps).Offset(pageNum).Limit(pageSize).Find(&articles)

    return
}
```

`Preload`就是一个预加载器，它会执行两条 SQL，分别是`SELECT * FROM blog_articles;`和`SELECT * FROM blog_tag WHERE id IN (1,2,3,4);`，那么在查询出结构后，`gorm`内部处理对应的映射逻辑，将其填充到`Article`的`Tag`中，会特别方便，并且避免了循环查询

那么有没有别的办法呢，大致是两种

- `gorm`的`Join`
- 循环`Related`

综合之下，还是`Preload`更好，如果你有更优的方案，欢迎说一下 :)

**3、 `v.(I)` 是什么？**

`v`表示一个接口值，`I`表示接口类型。这个实际就是 Golang 中的**类型断言**，用于判断一个接口值的实际类型是否为某个类型，或一个非接口值的类型是否实现了某个接口类型

------

打开`routers`目录下 v1 版本的`article.go`文件，修改文件内容：

```go
package v1

import (
    "net/http"
    "log"

    "github.com/gin-gonic/gin"
    "github.com/astaxie/beego/validation"
    "github.com/unknwon/com"

    "github.com/EDDYCJY/go-gin-example/models"
    "github.com/EDDYCJY/go-gin-example/pkg/e"
    "github.com/EDDYCJY/go-gin-example/pkg/setting"
    "github.com/EDDYCJY/go-gin-example/pkg/util"
)

//获取单个文章
func GetArticle(c *gin.Context) {
    id := com.StrTo(c.Param("id")).MustInt()

    valid := validation.Validation{}
    valid.Min(id, 1, "id").Message("ID必须大于0")

    code := e.INVALID_PARAMS
    var data interface {}
    if ! valid.HasErrors() {
        if models.ExistArticleByID(id) {
            data = models.GetArticle(id)
            code = e.SUCCESS
        } else {
            code = e.ERROR_NOT_EXIST_ARTICLE
        }
    } else {
        for _, err := range valid.Errors {
            log.Printf("err.key: %s, err.message: %s", err.Key, err.Message)
        }
    }

    c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : data,
    })
}

//获取多个文章
func GetArticles(c *gin.Context) {
    data := make(map[string]interface{})
    maps := make(map[string]interface{})
    valid := validation.Validation{}

    var state int = -1
    if arg := c.Query("state"); arg != "" {
        state = com.StrTo(arg).MustInt()
        maps["state"] = state

        valid.Range(state, 0, 1, "state").Message("状态只允许0或1")
    }

    var tagId int = -1
    if arg := c.Query("tag_id"); arg != "" {
        tagId = com.StrTo(arg).MustInt()
        maps["tag_id"] = tagId

        valid.Min(tagId, 1, "tag_id").Message("标签ID必须大于0")
    }

    code := e.INVALID_PARAMS
    if ! valid.HasErrors() {
        code = e.SUCCESS

        data["lists"] = models.GetArticles(util.GetPage(c), setting.PageSize, maps)
        data["total"] = models.GetArticleTotal(maps)

    } else {
        for _, err := range valid.Errors {
            log.Printf("err.key: %s, err.message: %s", err.Key, err.Message)
        }
    }

    c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : data,
    })
}

//新增文章
func AddArticle(c *gin.Context) {
    tagId := com.StrTo(c.Query("tag_id")).MustInt()
    title := c.Query("title")
    desc := c.Query("desc")
    content := c.Query("content")
    createdBy := c.Query("created_by")
    state := com.StrTo(c.DefaultQuery("state", "0")).MustInt()

    valid := validation.Validation{}
    valid.Min(tagId, 1, "tag_id").Message("标签ID必须大于0")
    valid.Required(title, "title").Message("标题不能为空")
    valid.Required(desc, "desc").Message("简述不能为空")
    valid.Required(content, "content").Message("内容不能为空")
    valid.Required(createdBy, "created_by").Message("创建人不能为空")
    valid.Range(state, 0, 1, "state").Message("状态只允许0或1")

    code := e.INVALID_PARAMS
    if ! valid.HasErrors() {
        if models.ExistTagByID(tagId) {
            data := make(map[string]interface {})
            data["tag_id"] = tagId
            data["title"] = title
            data["desc"] = desc
            data["content"] = content
            data["created_by"] = createdBy
            data["state"] = state

            models.AddArticle(data)
            code = e.SUCCESS
        } else {
            code = e.ERROR_NOT_EXIST_TAG
        }
    } else {
        for _, err := range valid.Errors {
            log.Printf("err.key: %s, err.message: %s", err.Key, err.Message)
        }
    }

    c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : make(map[string]interface{}),
    })
}

//修改文章
func EditArticle(c *gin.Context) {
    valid := validation.Validation{}

    id := com.StrTo(c.Param("id")).MustInt()
    tagId := com.StrTo(c.Query("tag_id")).MustInt()
    title := c.Query("title")
    desc := c.Query("desc")
    content := c.Query("content")
    modifiedBy := c.Query("modified_by")

    var state int = -1
    if arg := c.Query("state"); arg != "" {
        state = com.StrTo(arg).MustInt()
        valid.Range(state, 0, 1, "state").Message("状态只允许0或1")
    }

    valid.Min(id, 1, "id").Message("ID必须大于0")
    valid.MaxSize(title, 100, "title").Message("标题最长为100字符")
    valid.MaxSize(desc, 255, "desc").Message("简述最长为255字符")
    valid.MaxSize(content, 65535, "content").Message("内容最长为65535字符")
    valid.Required(modifiedBy, "modified_by").Message("修改人不能为空")
    valid.MaxSize(modifiedBy, 100, "modified_by").Message("修改人最长为100字符")

    code := e.INVALID_PARAMS
    if ! valid.HasErrors() {
        if models.ExistArticleByID(id) {
            if models.ExistTagByID(tagId) {
                data := make(map[string]interface {})
                if tagId > 0 {
                    data["tag_id"] = tagId
                }
                if title != "" {
                    data["title"] = title
                }
                if desc != "" {
                    data["desc"] = desc
                }
                if content != "" {
                    data["content"] = content
                }

                data["modified_by"] = modifiedBy

                models.EditArticle(id, data)
                code = e.SUCCESS
            } else {
                code = e.ERROR_NOT_EXIST_TAG
            }
        } else {
            code = e.ERROR_NOT_EXIST_ARTICLE
        }
    } else {
        for _, err := range valid.Errors {
            log.Printf("err.key: %s, err.message: %s", err.Key, err.Message)
        }
    }

    c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : make(map[string]string),
    })
}

//删除文章
func DeleteArticle(c *gin.Context) {
    id := com.StrTo(c.Param("id")).MustInt()

    valid := validation.Validation{}
    valid.Min(id, 1, "id").Message("ID必须大于0")

    code := e.INVALID_PARAMS
    if ! valid.HasErrors() {
        if models.ExistArticleByID(id) {
            models.DeleteArticle(id)
            code = e.SUCCESS
        } else {
            code = e.ERROR_NOT_EXIST_ARTICLE
        }
    } else {
        for _, err := range valid.Errors {
            log.Printf("err.key: %s, err.message: %s", err.Key, err.Message)
        }
    }

    c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : make(map[string]string),
    })
}
```

当前目录结构：

```
go-gin-example/
├── conf
│   └── app.ini
├── main.go
├── middleware
├── models
│   ├── article.go
│   ├── models.go
│   └── tag.go
├── pkg
│   ├── e
│   │   ├── code.go
│   │   └── msg.go
│   ├── setting
│   │   └── setting.go
│   └── util
│       └── pagination.go
├── routers
│   ├── api
│   │   └── v1
│   │       ├── article.go
│   │       └── tag.go
│   └── router.go
├── runtime
```

## 验证功能

我们重启服务，执行`go run main.go`，检查控制台输出结果

```
$ go run main.go
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /api/v1/tags              --> gin-blog/routers/api/v1.GetTags (3 handlers)
[GIN-debug] POST   /api/v1/tags              --> gin-blog/routers/api/v1.AddTag (3 handlers)
[GIN-debug] PUT    /api/v1/tags/:id          --> gin-blog/routers/api/v1.EditTag (3 handlers)
[GIN-debug] DELETE /api/v1/tags/:id          --> gin-blog/routers/api/v1.DeleteTag (3 handlers)
[GIN-debug] GET    /api/v1/articles          --> gin-blog/routers/api/v1.GetArticles (3 handlers)
[GIN-debug] GET    /api/v1/articles/:id      --> gin-blog/routers/api/v1.GetArticle (3 handlers)
[GIN-debug] POST   /api/v1/articles          --> gin-blog/routers/api/v1.AddArticle (3 handlers)
[GIN-debug] PUT    /api/v1/articles/:id      --> gin-blog/routers/api/v1.EditArticle (3 handlers)
[GIN-debug] DELETE /api/v1/articles/:id      --> gin-blog/routers/api/v1.DeleteArticle (3 handlers)
```

使用`Postman`检验接口是否正常，在这里大家可以选用合适的参数传递方式，此处为了方便展示我选用了 GET/Param 传参的方式，而后期会改为 POST。

- POST：http://127.0.0.1:8000/api/v1/articles?tag_id=1&title=test1&desc=test-desc&content=test-content&created_by=test-created&state=1
- GET：http://127.0.0.1:8000/api/v1/articles
- GET：http://127.0.0.1:8000/api/v1/articles/1
- PUT：http://127.0.0.1:8000/api/v1/articles/1?tag_id=1&title=test-edit1&desc=test-desc-edit&content=test-content-edit&modified_by=test-created-edit&state=0
- DELETE：http://127.0.0.1:8000/api/v1/articles/1

至此，我们的 API’s 编写就到这里，下一节我们将介绍另外的一些技巧！

# 第一阶段完成

```bash
% go run main.go
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /api/v1/tags              --> github.com/panda8z/go-gin-example/routers/api/v1.GetTags (3 handlers)
[GIN-debug] POST   /api/v1/tags              --> github.com/panda8z/go-gin-example/routers/api/v1.AddTag (3 handlers)
[GIN-debug] PUT    /api/v1/tags/:id          --> github.com/panda8z/go-gin-example/routers/api/v1.EditTag (3 handlers)
[GIN-debug] DELETE /api/v1/tags/:id          --> github.com/panda8z/go-gin-example/routers/api/v1.DeleteTag (3 handlers)

(/Users/panda8z/gopath/pkg/mod/github.com/jinzhu/gorm@v0.0.0-20180213101209-6e1387b44c64/scope.go:1024) 
[2020-02-18 17:54:38]  [4.24ms]  SELECT * FROM `blog_tag`   LIMIT 10 OFFSET 0  
[0 rows affected or returned ] 

(/Users/panda8z/gopath/pkg/mod/github.com/jinzhu/gorm@v0.0.0-20180213101209-6e1387b44c64/scope.go:1024) 
[2020-02-18 17:54:38]  [8.21ms]  SELECT count(*) FROM `blog_tag`    
[0 rows affected or returned ] 
[GIN] 2020/02/18 - 17:54:38 | 200 |   13.093875ms |       127.0.0.1 | GET      /api/v1/tags
```

#

# 使用 JWT 进行身份校验

## 涉及知识点

- JWT

## 本文目标

在前面几节中，我们已经基本的完成了 API’s 的编写，但是，还存在一些非常严重的问题，例如，我们现在的 API 是可以随意调用的，这显然还不安全全，在本文中我们通过 [jwt-go](https://github.com/dgrijalva/jwt-go) （[GoDoc](https://godoc.org/github.com/dgrijalva/jwt-go)）的方式来简单解决这个问题。

## 下载依赖包

首先，我们下载 jwt-go 的依赖包，如下：

```
go get -u github.com/dgrijalva/jwt-go
```

## 编写 jwt 工具包

我们需要编写一个`jwt`的工具包，我们在`pkg`下的`util`目录新建`jwt.go`，写入文件内容：

```go
package util

import (
	"time"

	jwt "github.com/dgrijalva/jwt-go"

	"github.com/EDDYCJY/go-gin-example/pkg/setting"
)

var jwtSecret = []byte(setting.JwtSecret)

type Claims struct {
	Username string `json:"username"`
	Password string `json:"password"`
	jwt.StandardClaims
}

func GenerateToken(username, password string) (string, error) {
	nowTime := time.Now()
	expireTime := nowTime.Add(3 * time.Hour)

	claims := Claims{
		username,
		password,
		jwt.StandardClaims {
			ExpiresAt : expireTime.Unix(),
			Issuer : "gin-blog",
		},
	}

	tokenClaims := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	token, err := tokenClaims.SignedString(jwtSecret)

	return token, err
}

func ParseToken(token string) (*Claims, error) {
	tokenClaims, err := jwt.ParseWithClaims(token, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})

	if tokenClaims != nil {
		if claims, ok := tokenClaims.Claims.(*Claims); ok && tokenClaims.Valid {
			return claims, nil
		}
	}

	return nil, err
}
```

在这个工具包，我们涉及到

- `NewWithClaims(method SigningMethod, claims Claims)`，`method`对应着`SigningMethodHMAC struct{}`，其包含`SigningMethodHS256`、`SigningMethodHS384`、`SigningMethodHS512`三种`crypto.Hash`方案
- `func (t *Token) SignedString(key interface{})` 该方法内部生成签名字符串，再用于获取完整、已签名的`token`
- `func (p *Parser) ParseWithClaims` 用于解析鉴权的声明，[方法内部](https://gowalker.org/github.com/dgrijalva/jwt-go#Parser_ParseWithClaims)主要是具体的解码和校验的过程，最终返回`*Token`
- `func (m MapClaims) Valid()` 验证基于时间的声明`exp, iat, nbf`，注意如果没有任何声明在令牌中，仍然会被认为是有效的。并且对于时区偏差没有计算方法

有了`jwt`工具包，接下来我们要编写要用于`Gin`的中间件，我们在`middleware`下新建`jwt`目录，新建`jwt.go`文件，写入内容：

```go
package jwt

import (
	"time"
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/EDDYCJY/go-gin-example/pkg/util"
	"github.com/EDDYCJY/go-gin-example/pkg/e"
)

func JWT() gin.HandlerFunc {
	return func(c *gin.Context) {
		var code int
		var data interface{}

		code = e.SUCCESS
		token := c.Query("token")
		if token == "" {
			code = e.INVALID_PARAMS
		} else {
			claims, err := util.ParseToken(token)
			if err != nil {
				code = e.ERROR_AUTH_CHECK_TOKEN_FAIL
			} else if time.Now().Unix() > claims.ExpiresAt {
				code = e.ERROR_AUTH_CHECK_TOKEN_TIMEOUT
			}
		}

		if code != e.SUCCESS {
			c.JSON(http.StatusUnauthorized, gin.H{
		        "code" : code,
		        "msg" : e.GetMsg(code),
		        "data" : data,
		    })

		    c.Abort()
		    return
		}

		c.Next()
	}
}
```

## 如何获取`Token`

那么我们如何调用它呢，我们还要获取`Token`呢？

1、 我们要新增一个获取`Token`的 API

在`models`下新建`auth.go`文件，写入内容：

```go
package models

type Auth struct {
	ID int `gorm:"primary_key" json:"id"`
	Username string `json:"username"`
	Password string `json:"password"`
}

func CheckAuth(username, password string) bool {
	var auth Auth
	db.Select("id").Where(Auth{Username : username, Password : password}).First(&auth)
	if auth.ID > 0 {
		return true
	}

	return false
}
```

在`routers`下的`api`目录新建`auth.go`文件，写入内容：

```go
package api

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/astaxie/beego/validation"

	"github.com/EDDYCJY/go-gin-example/pkg/e"
	"github.com/EDDYCJY/go-gin-example/pkg/util"
	"github.com/EDDYCJY/go-gin-example/models"
)

type auth struct {
	Username string `valid:"Required; MaxSize(50)"`
	Password string `valid:"Required; MaxSize(50)"`
}

func GetAuth(c *gin.Context) {
	username := c.Query("username")
	password := c.Query("password")

	valid := validation.Validation{}
	a := auth{Username: username, Password: password}
	ok, _ := valid.Valid(&a)

	data := make(map[string]interface{})
	code := e.INVALID_PARAMS
	if ok {
		isExist := models.CheckAuth(username, password)
		if isExist {
			token, err := util.GenerateToken(username, password)
			if err != nil {
				code = e.ERROR_AUTH_TOKEN
			} else {
				data["token"] = token

				code = e.SUCCESS
			}

		} else {
			code = e.ERROR_AUTH
		}
	} else {
		for _, err := range valid.Errors {
            log.Println(err.Key, err.Message)
        }
	}

	c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : data,
    })
}
```

我们打开`routers`目录下的`router.go`文件，修改文件内容（新增获取 token 的方法）：

```go
package routers

import (
    "github.com/gin-gonic/gin"

    "github.com/EDDYCJY/go-gin-example/routers/api"
    "github.com/EDDYCJY/go-gin-example/routers/api/v1"
    "github.com/EDDYCJY/go-gin-example/pkg/setting"
)

func InitRouter() *gin.Engine {
    r := gin.New()

    r.Use(gin.Logger())

    r.Use(gin.Recovery())

    gin.SetMode(setting.RunMode)

    r.GET("/auth", api.GetAuth)

    apiv1 := r.Group("/api/v1")
    {
        ...
    }

    return r
}
```

## 验证`Token`

获取`token`的 API 方法就到这里啦，让我们来测试下是否可以正常使用吧！

重启服务后，用`GET`方式访问`http://127.0.0.1:8000/auth?username=test&password=test123456`，查看返回值是否正确

```json
{
  "code": 200,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJwYXNzd29yZCI6InRlc3QxMjM0NTYiLCJleHAiOjE1MTg3MjAwMzcsImlzcyI6Imdpbi1ibG9nIn0.-kK0V9E06qTHOzupQM_gHXAGDB3EJtJS4H5TTCyWwW8"
  },
  "msg": "ok"
}
```

我们有了`token`的 API，也调用成功了

## 将中间件接入`Gin`

2、 接下来我们将中间件接入到`Gin`的访问流程中

我们打开`routers`目录下的`router.go`文件，修改文件内容（新增引用包和中间件引用）

```go
package routers

import (
    "github.com/gin-gonic/gin"

    "github.com/EDDYCJY/go-gin-example/routers/api"
    "github.com/EDDYCJY/go-gin-example/routers/api/v1"
    "github.com/EDDYCJY/go-gin-example/pkg/setting"
    "github.com/EDDYCJY/go-gin-example/middleware/jwt"
)

func InitRouter() *gin.Engine {
    r := gin.New()

    r.Use(gin.Logger())

    r.Use(gin.Recovery())

    gin.SetMode(setting.RunMode)

    r.GET("/auth", api.GetAuth)

    apiv1 := r.Group("/api/v1")
    apiv1.Use(jwt.JWT())
    {
        ...
    }

    return r
}
```

当前目录结构：

```
go-gin-example/
├── conf
│   └── app.ini
├── main.go
├── middleware
│   └── jwt
│       └── jwt.go
├── models
│   ├── article.go
│   ├── auth.go
│   ├── models.go
│   └── tag.go
├── pkg
│   ├── e
│   │   ├── code.go
│   │   └── msg.go
│   ├── setting
│   │   └── setting.go
│   └── util
│       ├── jwt.go
│       └── pagination.go
├── routers
│   ├── api
│   │   ├── auth.go
│   │   └── v1
│   │       ├── article.go
│   │       └── tag.go
│   └── router.go
├── runtime
```

到这里，我们的`JWT`编写就完成啦！

## 验证功能

我们来测试一下，再次访问

- http://127.0.0.1:8000/api/v1/articles
- http://127.0.0.1:8000/api/v1/articles?token=23131

正确的反馈应该是

```json
{
  "code": 400,
  "data": null,
  "msg": "请求参数错误"
}

{
  "code": 20001,
  "data": null,
  "msg": "Token鉴权失败"
}
```

我们需要访问`http://127.0.0.1:8000/auth?username=test&password=test123456`，得到`token`

```json
{
  "code": 200,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJwYXNzd29yZCI6InRlc3QxMjM0NTYiLCJleHAiOjE1MTg3MjQ2OTMsImlzcyI6Imdpbi1ibG9nIn0.KSBY6TeavV_30kfmP7HWLRYKP5TPEDgHtABe9HCsic4"
  },
  "msg": "ok"
}
```

再用包含`token`的 URL 参数去访问我们的应用 API，

访问`http://127.0.0.1:8000/api/v1/articles?token=eyJhbGci...`，检查接口返回值

```json
{
  "code": 200,
  "data": {
    "lists": [
      {
        "id": 2,
        "created_on": 1518700920,
        "modified_on": 0,
        "tag_id": 1,
        "tag": {
          "id": 1,
          "created_on": 1518684200,
          "modified_on": 0,
          "name": "tag1",
          "created_by": "",
          "modified_by": "",
          "state": 0
        },
        "content": "test-content",
        "created_by": "test-created",
        "modified_by": "",
        "state": 0
      }
    ],
    "total": 1
  },
  "msg": "ok"
}
```

返回正确，至此我们的`jwt-go`在`Gin`中的验证就完成了！