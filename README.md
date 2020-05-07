# 第一章 介绍与环境安装

## 本文目标

- 学会安装 Go。
- 知道什么是 Go。
- 知道什么是 Go modules。
- 了解 Go modules 的小历史。
- 学会简单的使用 Go modules。
- 了解 Gin，并简单跑起一个 Demo。

## 准备环节

### 安装 Go

#### Centos

首先，根据对应的操作系统选择安装包 [下载](https://studygolang.com/dl)，在这里我使用的是 Centos 64 位系统，如下：

```sh
$ wget https://studygolang.com/dl/golang/go1.13.1.linux-amd64.tar.gz

$ tar -zxvf go1.13.1.linux-amd64.tar.gz

$ mv go/ /usr/local/
```

配置 /etc/profile

```sh
vi /etc/profile
```

添加环境变量 GOROOT 和将 GOBIN 添加到 PATH 中

```sh
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
```

配置完毕后，执行命令令其生效

```sh
source /etc/profile
```

在控制台输入`go version`，若输出版本号则**安装成功**，如下：

```
$ go version
go version go1.13.1 linux/amd64
```

#### MacOS

在 MacOS 上安装 Go 最方便的办法就是使用 brew，安装如下：

```
$ brew install go
```

升级命令如下：

```
$ brew upgrade go
```

注：升级命令你不需要执行，但我想未来你有一天会用到的。

同样在控制台输入`go version`，若输出版本号则**安装成功**。

### 了解 Go

#### 是什么

> Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.

上述为官方说明，如果简单来讲，大致为如下几点：

- Go 是编程语言。
- 谷歌爸爸撑腰。
- 语言级高并发。
- 上手快，入门简单。
- 简洁，很有特色。
- 国内使用人群逐年增多。

#### 谁在用

![image](README/6d278b22a4c0bf29c6b89ece99cd6c88.jpg)

#### 有什么

那么大家会有些疑问，纠结 `Go` 本身有什么东西，我们刚刚设置的环境变量又有什么用呢，甚至作为一名老粉，你会纠结 GOPATH 去哪里了，我们一起接着往下看。

##### 目录结构

首先，我们在解压的时候会得到一个名为 `go` 的文件夹，其中包括了所有 `Go` 语言相关的一些文件，如下：

```
$ tree -L 1 go
go
├── api
├── bin
├── doc
├── lib
├── misc
├── pkg
├── src
├── test
└── ...
```

在这之中包含了很多文件夹和文件，我们来简单说明其中主要文件夹的作用：

- api：用于存放依照 `Go` 版本顺序的 API 增量列表文件。这里所说的 API 包含公开的变量、常量、函数等。这些 API 增量列表文件用于 `Go` 语言 API 检查
- bin：用于存放主要的标准命令文件（可执行文件），包含`go`、`godoc`、`gofmt`
- blog：用于存放官方博客中的所有文章
- doc：用于存放标准库的 HTML 格式的程序文档。我们可以通过`godoc`命令启动一个 Web 程序展示这些文档
- lib：用于存放一些特殊的库文件
- misc：用于存放一些辅助类的说明和工具
- pkg：用于存放安装`Go`标准库后的所有归档文件（以`.a`结尾的文件）。注意，你会发现其中有名称为`linux_amd64`的文件夹，我们称为平台相关目录。这类文件夹的名称由对应的操作系统和计算架构的名称组合而成。通过`go install`命令，`Go`程序会被编译成平台相关的归档文件存放到其中
- src：用于存放 `Go`自身、`Go` 标准工具以及标准库的所有源码文件
- test：存放用来测试和验证`Go`本身的所有相关文件

##### 环境变量

你可能会疑惑刚刚设置的环境变量是什么，如下：

- GOROOT：`Go`的根目录。
- PATH 下增加 `$GOROOT/bin`：`Go`的 `bin`下会存放可执行文件，我们把他加入 `$PATH` 后，未来拉下来并编译后的二进制文件就可以直接在命令行使用。

那在什么东西都不下载的情况下，`$GOBIN` 下面有什么呢，如下：

```
bin/ $ls
go  gofmt
```

- go：`Go` 二进制本身。
- gofmt：代码格式化工具。

因此我们刚刚把 `$GOBIN` 加入到 `$PATH` 后，你执行 `go version` 命令后就可以查看到对应的输出结果。

注：MacOS 用 brew 安装的话就不需要。

#### 放在哪

你现在知道 Go 是什么了，也知道 Go 的源码摆在哪了，你肯定会想，那我应用代码放哪呢，答案是在 **Go1.11+ 和开启 Go Modules 的情况下摆哪都行**。

### 了解 Go Modules

#### 了解历史

在过去，Go 的依赖包管理在工具上混乱且不统一，有 dep，有 glide，有 govendor…甚至还有因为外网的问题，频频导致拉不下来包，很多人苦不堪言，盼着官方给出一个大一统做出表率。

而在 Go modules 正式出来之前还有一个叫 dep 的项目，我们在上面有提到，它是 Go 的一个官方实验性项目，目的也是为了解决 Go 在依赖管理方面的问题，当时社区里面几乎所有的人都认为 dep 肯定就是未来 Go 官方的依赖管理解决方案了。

但是万万没想到，半路杀出个程咬金，Russ Cox 义无反顾地推出了 Go modules，这瞬间导致一石激起千层浪，让社区炸了锅。大家一致认为 Go team 实在是太霸道、太独裁了，连个招呼都不打一声。我记得当时有很多人在网上跟 Russ Cox 口水战，各种依赖管理解决方案的专家都冒出来发表意见，讨论范围甚至一度超出了 Go 语言的圈子触及到了其他语言的领域。

当然，最后，推成功了，Go modules 已经进入官方工具链中，与 Go 深深结合，以前常说的 GOPATH 终将会失去它原有的作用，而且它还提供了 GOPROXY 间接解决了国内访问外网的问题。

#### 了解 Russ Cox

在上文中提到的 Russ Cox 是谁呢，他是 Go 这个项目目前代码提交量最多的人，甚至是第二名的两倍还要多（从 2019 年 09 月 30 日前来看）。

Russ Cox 还是 Go 现在的掌舵人（大家应该知道之前 Go 的掌舵人是 Rob Pike，但是听说由于他本人不喜欢特朗普执政所以离开了美国，然后他岁数也挺大的了，所以也正在逐渐交权，不过现在还是在参与 Go 的发展）。

Russ Cox 的个人能力相当强，看问题的角度也很独特，这也就是为什么他刚一提出 Go modules 的概念就能引起那么大范围的响应。虽然是被强推的，但事实也证明当下的 Go modules 表现得确实很优秀，所以这表明一定程度上的 “独裁” 还是可以接受的，至少可以保证一个项目能更加专一地朝着一个方向发展。

#### 初始化行为

在前面我们已经了解到 Go 依赖包管理的历史情况，接下来我们将正式的进入使用，首先你需要有一个你喜欢的目录，例如：`$ mkdir ~/go-application && cd ~/go-application`，然后执行如下命令：

```
$ mkdir go-gin-example && cd go-gin-example

$ go env -w GO111MODULE=on

$ go env -w GOPROXY=https://goproxy.cn,direct

$ go mod init github.com/EDDYCJY/go-gin-example
go: creating new go.mod: module github.com/EDDYCJY/go-gin-example

$ ls
go.mod
```

- `mkdir xxx && cd xxx`：创建并切换到项目目录里去。
- `go env -w GO111MODULE=on`：打开 Go modules 开关（目前在 Go1.13 中默认值为 `auto`）。
- `go env -w GOPROXY=...`：设置 GOPROXY 代理，这里主要涉及到两个值，第一个是 `https://goproxy.cn`，它是由七牛云背书的一个强大稳定的 Go 模块代理，可以有效地解决你的外网问题；第二个是 `direct`，它是一个特殊的 fallback 选项，它的作用是用于指示 Go 在拉取模块时遇到错误会回源到模块版本的源地址去抓取（比如 GitHub 等）。
- `go mod init [MODULE_PATH]`：初始化 Go modules，它将会生成 go.mod 文件，需要注意的是 `MODULE_PATH` 填写的是模块引入路径，你可以根据自己的情况修改路径。

在执行了上述步骤后，初始化工作已完成，我们打开 `go.mod` 文件看看，如下：

```
module github.com/EDDYCJY/go-gin-example

go 1.13
```

默认的 `go.mod` 文件里主要是两块内容，一个是当前的模块路径和预期的 Go 语言版本。

#### 基础使用

- 用

   

  ```
  go get
  ```

   

  拉取新的依赖

  - 拉取最新的版本(优先择取 tag)：`go get golang.org/x/text@latest`
  - 拉取 `master` 分支的最新 commit：`go get golang.org/x/text@master`
  - 拉取 tag 为 v0.3.2 的 commit：`go get golang.org/x/text@v0.3.2`
  - 拉取 hash 为 342b231 的 commit，最终会被转换为 v0.3.2：`go get golang.org/x/text@342b2e`
  - 用 `go get -u` 更新现有的依赖
  - 用 `go mod download` 下载 go.mod 文件中指明的所有依赖
  - 用 `go mod tidy` 整理现有的依赖
  - 用 `go mod graph` 查看现有的依赖结构
  - 用 `go mod init` 生成 go.mod 文件 (Go 1.13 中唯一一个可以生成 go.mod 文件的子命令)

- 用 `go mod edit` 编辑 go.mod 文件

- 用 `go mod vendor` 导出现有的所有依赖 (事实上 Go modules 正在淡化 Vendor 的概念)

- 用 `go mod verify` 校验一个模块是否被篡改过

这一小节主要是针对 Go modules 的基础使用讲解，还没具体的使用，是希望你能够留个印象，因为在后面章节会不断夹杂 Go modules 的知识点。

注：建议阅读官方文档 [wiki/Modules](https://github.com/golang/go/wiki/Modules)。

## 开始 Gin 之旅

### 是什么

> Gin is a HTTP web framework written in Go (Golang). It features a Martini-like API with much better performance – up to 40 times faster. If you need smashing performance, get yourself some Gin.

Gin 是用 Go 开发的一个微框架，类似 Martinier 的 API，重点是小巧、易用、性能好很多，也因为 [httprouter](https://github.com/julienschmidt/httprouter) 的性能提高了 40 倍。

### 安装

我们回到刚刚创建的 `go-gin-example` 目录下，在命令行下执行如下命令：

```sh
$ go get -u github.com/gin-gonic/gin
go: downloading golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223
go: extracting golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223
go: finding github.com/gin-contrib/sse v0.1.0
go: finding github.com/ugorji/go v1.1.7
go: finding gopkg.in/yaml.v2 v2.2.3
go: finding golang.org/x/sys latest
go: finding github.com/mattn/go-isatty v0.0.9
go: finding github.com/modern-go/concurrent latest
...
```

#### go.sum

这时候你再检查一下该目录下，会发现多个了个 `go.sum` 文件，如下：

```
github.com/davecgh/go-spew v1.1.0/go.mod h1:J7Y8YcW...
github.com/davecgh/go-spew v1.1.1/go.mod h1:J7Y8YcW...
github.com/gin-contrib/sse v0.0.0-20190301062529-5545eab6dad3 h1:t8FVkw33L+wilf2QiWkw0UV77qRpcH/JHPKGpKa2E8g=
github.com/gin-contrib/sse v0.0.0-20190301062529-5545eab6dad3/go.mod h1:VJ0WA2...
github.com/gin-contrib/sse v0.1.0 h1:Y/yl/+YNO...
...
```

`go.sum` 文件详细罗列了当前项目直接或间接依赖的所有模块版本，并写明了那些模块版本的 SHA-256 哈希值以备 Go 在今后的操作中保证项目所依赖的那些模块版本不会被篡改。

#### go.mod

既然我们下载了依赖包，`go.mod` 文件会不会有所改变呢，我们再去看看，如下：

```
module github.com/EDDYCJY/go-gin-example

go 1.13

require (
        github.com/gin-contrib/sse v0.1.0 // indirect
        github.com/gin-gonic/gin v1.4.0 // indirect
        github.com/golang/protobuf v1.3.2 // indirect
        github.com/json-iterator/go v1.1.7 // indirect
        github.com/mattn/go-isatty v0.0.9 // indirect
        github.com/ugorji/go v1.1.7 // indirect
        golang.org/x/sys v0.0.0-20190927073244-c990c680b611 // indirect
        gopkg.in/yaml.v2 v2.2.3 // indirect
)
```

确确实实发生了改变，那多出来的东西又是什么呢，`go.mod` 文件又保存了什么信息呢，实际上 `go.mod` 文件是启用了 Go modules 的项目所必须的最重要的文件，因为它描述了当前项目（也就是当前模块）的元信息，每一行都以一个动词开头，目前有以下 5 个动词:

- module：用于定义当前项目的模块路径。
- go：用于设置预期的 Go 版本。
- require：用于设置一个特定的模块版本。
- exclude：用于从使用中排除一个特定的模块版本。
- replace：用于将一个模块版本替换为另外一个模块版本。

你可能还会疑惑 `indirect` 是什么东西，`indirect` 的意思是传递依赖，也就是非直接依赖。

### 测试

编写一个`test.go`文件

```go
package main

import "github.com/gin-gonic/gin"

func main() {
  r := gin.Default()
  r.GET("/ping", func(c *gin.Context) {
    c.JSON(200, gin.H{
      "message": "pong",
    })
  })
  r.Run() // listen and serve on 0.0.0.0:8080
}
```

执行`test.go`

```sh
$ go run test.go
...
[GIN-debug] GET    /ping                     --> main.main.func1 (3 handlers)
[GIN-debug] Environment variable PORT is undefined. Using port :8080 by default
[GIN-debug] Listening and serving HTTP on :8080
```

访问 `$HOST:8080/ping`，若返回`{"message":"pong"}`则正确

```sh
curl 127.0.0.1:8080/ping
```

至此，我们的环境安装和初步运行都基本完成了。

## 再想一想

刚刚在执行了命令 `$ go get -u github.com/gin-gonic/gin` 后，我们查看了 `go.mod` 文件，如下：

```
...
require (
        github.com/gin-contrib/sse v0.1.0 // indirect
        github.com/gin-gonic/gin v1.4.0 // indirect
        ...
)
```

你会发现 `go.mod` 里的 `github.com/gin-gonic/gin` 是 `indirect` 模式，这显然不对啊，因为我们的应用程序已经实际的编写了 gin server 代码了，我就想把它调对，怎么办呢，在应用根目录下执行如下命令：

```
$ go mod tidy
```

该命令主要的作用是整理现有的依赖，非常的常用，执行后 `go.mod` 文件内容为：

```
...
require (
        github.com/gin-contrib/sse v0.1.0 // indirect
        github.com/gin-gonic/gin v1.4.0
        ...
)
```

可以看到 `github.com/gin-gonic/gin` 已经变成了直接依赖，调整完毕。

## 参考

### 本系列示例代码

- [go-gin-example](https://github.com/EDDYCJY/go-gin-example)

### 相关文档

- [Gin](https://github.com/gin-gonic/gin)
- [Gin Web Framework](https://gin-gonic.github.io/gin/)
- [干货满满的 Go Modules 和 goproxy.cn](https://book.eddycjy.com/golang/talk/goproxy-cn.html)

## 关于

### 修改记录

- 第一版：2018 年 02 月 16 日发布文章
- 第二版：2019 年 10 月 01 日修改文章

## ？

如果有任何疑问或错误，欢迎在 [issues](https://github.com/EDDYCJY/blog) 进行提问或给予修正意见，如果喜欢或对你有所帮助，欢迎 Star，对作者是一种鼓励和推进。

# 第二章 Gin搭建Blog API's （一）

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



# 第三章 搭建Blog API's （二）

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





# 第四章 Gin搭建Blog API's （三）

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

# 第五章 使用 JWT 进行身份校验

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





# 第六章 编写一个简单的文件日志

## 涉及知识点

- 自定义 log。

## 本文目标

在上一节中，我们解决了 API’s 可以任意访问的问题，那么我们现在还有一个问题，就是我们的日志，都是输出到控制台上的，这显然对于一个项目来说是不合理的，因此我们这一节简单封装`log`库，使其支持简单的文件日志！

## 新建`logging`包

我们在`pkg`下新建`logging`目录，新建`file.go`和`log.go`文件，写入内容：

### 编写`file`文件

**1、 file.go：**

```go
package logging

import (
	"os"
	"time"
	"fmt"
	"log"
)

var (
	LogSavePath = "runtime/logs/"
	LogSaveName = "log"
	LogFileExt = "log"
	TimeFormat = "20060102"
)

func getLogFilePath() string {
	return fmt.Sprintf("%s", LogSavePath)
}

func getLogFileFullPath() string {
	prefixPath := getLogFilePath()
	suffixPath := fmt.Sprintf("%s%s.%s", LogSaveName, time.Now().Format(TimeFormat), LogFileExt)

	return fmt.Sprintf("%s%s", prefixPath, suffixPath)
}

func openLogFile(filePath string) *os.File {
	_, err := os.Stat(filePath)
	switch {
		case os.IsNotExist(err):
			mkDir()
		case os.IsPermission(err):
			log.Fatalf("Permission :%v", err)
	}

	handle, err := os.OpenFile(filePath, os.O_APPEND | os.O_CREATE | os.O_WRONLY, 0644)
	if err != nil {
		log.Fatalf("Fail to OpenFile :%v", err)
	}

	return handle
}

func mkDir() {
	dir, _ := os.Getwd()
	err := os.MkdirAll(dir + "/" + getLogFilePath(), os.ModePerm)
	if err != nil {
		panic(err)
	}
}
```

- `os.Stat`：返回文件信息结构描述文件。如果出现错误，会返回`*PathError`

```go
type PathError struct {
    Op   string
    Path string
    Err  error
}
```

- `os.IsNotExist`：能够接受`ErrNotExist`、`syscall`的一些错误，它会返回一个布尔值，能够得知文件不存在或目录不存在
- `os.IsPermission`：能够接受`ErrPermission`、`syscall`的一些错误，它会返回一个布尔值，能够得知权限是否满足
- `os.OpenFile`：调用文件，支持传入文件名称、指定的模式调用文件、文件权限，返回的文件的方法可以用于 I/O。如果出现错误，则为`*PathError`。

```go
const (
    // Exactly one of O_RDONLY, O_WRONLY, or O_RDWR must be specified.
    O_RDONLY int = syscall.O_RDONLY // 以只读模式打开文件
    O_WRONLY int = syscall.O_WRONLY // 以只写模式打开文件
    O_RDWR   int = syscall.O_RDWR   // 以读写模式打开文件
    // The remaining values may be or'ed in to control behavior.
    O_APPEND int = syscall.O_APPEND // 在写入时将数据追加到文件中
    O_CREATE int = syscall.O_CREAT  // 如果不存在，则创建一个新文件
    O_EXCL   int = syscall.O_EXCL   // 使用O_CREATE时，文件必须不存在
    O_SYNC   int = syscall.O_SYNC   // 同步IO
    O_TRUNC  int = syscall.O_TRUNC  // 如果可以，打开时
)
```

- `os.Getwd`：返回与当前目录对应的根路径名
- `os.MkdirAll`：创建对应的目录以及所需的子目录，若成功则返回`nil`，否则返回`error`
- `os.ModePerm`：`const`定义`ModePerm FileMode = 0777`

### 编写`log`文件

**2、log.go**

```go
package logging

import (
	"log"
	"os"
	"runtime"
	"path/filepath"
	"fmt"
)

type Level int

var (
	F *os.File

	DefaultPrefix = ""
	DefaultCallerDepth = 2

	logger *log.Logger
	logPrefix = ""
	levelFlags = []string{"DEBUG", "INFO", "WARN", "ERROR", "FATAL"}
)

const (
	DEBUG Level = iota
	INFO
	WARNING
	ERROR
	FATAL
)

func init() {
	filePath := getLogFileFullPath()
	F = openLogFile(filePath)

	logger = log.New(F, DefaultPrefix, log.LstdFlags)
}

func Debug(v ...interface{}) {
	setPrefix(DEBUG)
	logger.Println(v)
}

func Info(v ...interface{}) {
	setPrefix(INFO)
	logger.Println(v)
}

func Warn(v ...interface{}) {
	setPrefix(WARNING)
	logger.Println(v)
}

func Error(v ...interface{}) {
	setPrefix(ERROR)
	logger.Println(v)
}

func Fatal(v ...interface{}) {
	setPrefix(FATAL)
	logger.Fatalln(v)
}

func setPrefix(level Level) {
	_, file, line, ok := runtime.Caller(DefaultCallerDepth)
	if ok {
		logPrefix = fmt.Sprintf("[%s][%s:%d]", levelFlags[level], filepath.Base(file), line)
	} else {
		logPrefix = fmt.Sprintf("[%s]", levelFlags[level])
	}

	logger.SetPrefix(logPrefix)
}
```

- `log.New`：创建一个新的日志记录器。`out`定义要写入日志数据的`IO`句柄。`prefix`定义每个生成的日志行的开头。`flag`定义了日志记录属性

```go
func New(out io.Writer, prefix string, flag int) *Logger {
    return &Logger{out: out, prefix: prefix, flag: flag}
}
```

- `log.LstdFlags`：日志记录的格式属性之一，其余的选项如下

```go
const (
    Ldate         = 1 << iota     // the date in the local time zone: 2009/01/23
    Ltime                         // the time in the local time zone: 01:23:23
    Lmicroseconds                 // microsecond resolution: 01:23:23.123123.  assumes Ltime.
    Llongfile                     // full file name and line number: /a/b/c/d.go:23
    Lshortfile                    // final file name element and line number: d.go:23. overrides Llongfile
    LUTC                          // if Ldate or Ltime is set, use UTC rather than the local time zone
    LstdFlags     = Ldate | Ltime // initial values for the standard logger
)
```

当前目录结构：

```
gin-blog/
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
│   ├── logging
│   │   ├── file.go
│   │   └── log.go
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

我们自定义的`logging`包，已经基本完成了，接下来让它接入到我们的项目之中吧。我们打开先前包含`log`包的代码，如下：

1. 打开`routers`目录下的`article.go`、`tag.go`、`auth.go`。
2. 将`log`包的引用删除，修改引用我们自己的日志包为`github.com/EDDYCJY/go-gin-example/pkg/logging`。
3. 将原本的`log.Println(...)`改为`logging.Info(...)`。

例如`auth.go`文件的修改内容：

```go
package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/astaxie/beego/validation"

	"github.com/EDDYCJY/go-gin-example/pkg/e"
	"github.com/EDDYCJY/go-gin-example/pkg/util"
	"github.com/EDDYCJY/go-gin-example/models"
	"github.com/EDDYCJY/go-gin-example/pkg/logging"
)
...
func GetAuth(c *gin.Context) {
	...
	code := e.INVALID_PARAMS
	if ok {
		...
	} else {
	    for _, err := range valid.Errors {
                logging.Info(err.Key, err.Message)
            }
	}

	c.JSON(http.StatusOK, gin.H{
        "code" : code,
        "msg" : e.GetMsg(code),
        "data" : data,
    })
}
```

## 验证功能

修改文件后，重启服务，我们来试试吧！

获取到 API 的 Token 后，我们故意传错误 URL 参数给接口，如：`http://127.0.0.1:8000/api/v1/articles?tag_id=0&state=9999999&token=eyJhbG..`

然后我们到`$GOPATH/gin-blog/runtime/logs`查看日志：

```
$ tail -f log20180216.log
[INFO][article.go:79]2018/02/16 18:33:12 [state 状态只允许0或1]
[INFO][article.go:79]2018/02/16 18:33:42 [state 状态只允许0或1]
[INFO][article.go:79]2018/02/16 18:33:42 [tag_id 标签ID必须大于0]
[INFO][article.go:79]2018/02/16 18:38:39 [state 状态只允许0或1]
[INFO][article.go:79]2018/02/16 18:38:39 [tag_id 标签ID必须大于0]
```

日志结构一切正常，我们的记录模式都为`Info`，因此前缀是对的，并且我们是入参有问题，也把错误记录下来了，这样排错就很方便了！

至此，本节就完成了，这只是一个简单的扩展，实际上我们线上项目要使用的文件日志，是更复杂一些，开动你的大脑 举一反三吧！





# 第七章 优雅的重启服务

## 知识点

- 信号量的了解。
- 应用热更新。

## 本文目标

在前面编写案例代码时，我相信你会想到，每次更新完代码，更新完配置文件后，就直接这么 `ctrl+c` 真的没问题吗，`ctrl+c`到底做了些什么事情呢？

在这一节中我们简单讲述 `ctrl+c` 背后的**信号**以及如何在`Gin`中**优雅的重启服务**，也就是对 `HTTP` 服务进行热更新。

## ctrl + c

> 内核在某些情况下发送信号，比如在进程往一个已经关闭的管道写数据时会产生`SIGPIPE`信号

在终端执行特定的组合键可以使系统发送特定的信号给此进程，完成一系列的动作

| 命令     | 信号    | 含义                                                         |
| -------- | ------- | ------------------------------------------------------------ |
| ctrl + c | SIGINT  | 强制进程结束                                                 |
| ctrl + z | SIGTSTP | 任务中断，进程挂起                                           |
| ctrl + \ | SIGQUIT | 进程结束 和 `dump core`                                      |
| ctrl + d |         | EOF                                                          |
|          | SIGHUP  | 终止收到该信号的进程。若程序中没有捕捉该信号，当收到该信号时，进程就会退出（常用于 重启、重新加载进程） |

因此在我们执行`ctrl + c`关闭`gin`服务端时，**会强制进程结束，导致正在访问的用户等出现问题**

常见的 `kill -9 pid` 会发送 `SIGKILL` 信号给进程，也是类似的结果

### 信号

本段中反复出现**信号**是什么呢？

信号是 `Unix` 、类 `Unix` 以及其他 `POSIX` 兼容的操作系统中进程间通讯的一种有限制的方式

它是一种异步的通知机制，用来提醒进程一个事件（硬件异常、程序执行异常、外部发出信号）已经发生。当一个信号发送给一个进程，操作系统中断了进程正常的控制流程。此时，任何非原子操作都将被中断。如果进程定义了信号的处理函数，那么它将被执行，否则就执行默认的处理函数

### 所有信号

```
$ kill -l
 1) SIGHUP   2) SIGINT   3) SIGQUIT  4) SIGILL   5) SIGTRAP
 6) SIGABRT  7) SIGBUS   8) SIGFPE   9) SIGKILL 10) SIGUSR1
11) SIGSEGV 12) SIGUSR2 13) SIGPIPE 14) SIGALRM 15) SIGTERM
16) SIGSTKFLT   17) SIGCHLD 18) SIGCONT 19) SIGSTOP 20) SIGTSTP
21) SIGTTIN 22) SIGTTOU 23) SIGURG  24) SIGXCPU 25) SIGXFSZ
26) SIGVTALRM   27) SIGPROF 28) SIGWINCH    29) SIGIO   30) SIGPWR
31) SIGSYS  34) SIGRTMIN    35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
63) SIGRTMAX-1  64) SIGRTMAX
```

## 怎样算优雅

### 目的

- 不关闭现有连接（正在运行中的程序）
- 新的进程启动并替代旧进程
- 新的进程接管新的连接
- 连接要随时响应用户的请求，当用户仍在请求旧进程时要保持连接，新用户应请求新进程，不可以出现拒绝请求的情况

### 流程

1、替换可执行文件或修改配置文件

2、发送信号量 `SIGHUP`

3、拒绝新连接请求旧进程，但要保证已有连接正常

4、启动新的子进程

5、新的子进程开始 `Accet`

6、系统将新的请求转交新的子进程

7、旧进程处理完所有旧连接后正常结束

## 实现优雅重启

### endless

> Zero downtime restarts for golang HTTP and HTTPS servers. (for golang 1.3+)

我们借助 [fvbock/endless](https://github.com/fvbock/endless) 来实现 `Golang HTTP/HTTPS` 服务重新启动的零停机

`endless server` 监听以下几种信号量：

- syscall.SIGHUP：触发 `fork` 子进程和重新启动
- syscall.SIGUSR1/syscall.SIGTSTP：被监听，但不会触发任何动作
- syscall.SIGUSR2：触发 `hammerTime`
- syscall.SIGINT/syscall.SIGTERM：触发服务器关闭（会完成正在运行的请求）

`endless` 正正是依靠监听这些**信号量**，完成管控的一系列动作

#### 安装

```
go get -u github.com/fvbock/endless
```

#### 编写

打开 [gin-blog](https://github.com/EDDYCJY/go-gin-example) 的 `main.go`文件，修改文件：

```go
package main

import (
    "fmt"
    "log"
    "syscall"

    "github.com/fvbock/endless"

    "gin-blog/routers"
    "gin-blog/pkg/setting"
)

func main() {
    endless.DefaultReadTimeOut = setting.ReadTimeout
    endless.DefaultWriteTimeOut = setting.WriteTimeout
    endless.DefaultMaxHeaderBytes = 1 << 20
    endPoint := fmt.Sprintf(":%d", setting.HTTPPort)

    server := endless.NewServer(endPoint, routers.InitRouter())
    server.BeforeBegin = func(add string) {
        log.Printf("Actual pid is %d", syscall.Getpid())
    }

    err := server.ListenAndServe()
    if err != nil {
        log.Printf("Server err: %v", err)
    }
}
```

`endless.NewServer` 返回一个初始化的 `endlessServer` 对象，在 `BeforeBegin` 时输出当前进程的 `pid`，调用 `ListenAndServe` 将实际“启动”服务

#### 验证

##### **编译**

```
$ go build main.go
```

##### **执行**

```
$ ./main
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
...
Actual pid is 48601
```

启动成功后，输出了`pid`为 48601；在另外一个终端执行 `kill -1 48601` ，检验先前服务的终端效果

```
[root@localhost go-gin-example]# ./main
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /auth                     --> ...
[GIN-debug] GET    /api/v1/tags              --> ...
...

Actual pid is 48601

...

Actual pid is 48755
48601 Received SIGTERM.
48601 [::]:8000 Listener closed.
48601 Waiting for connections to finish...
48601 Serve() returning...
Server err: accept tcp [::]:8000: use of closed network connection
```

可以看到该命令已经挂起，并且 `fork` 了新的子进程 `pid` 为 `48755`

```
48601 Received SIGTERM.
48601 [::]:8000 Listener closed.
48601 Waiting for connections to finish...
48601 Serve() returning...
Server err: accept tcp [::]:8000: use of closed network connection
```

大致意思为主进程（`pid`为 48601）接受到 `SIGTERM` 信号量，关闭主进程的监听并且等待正在执行的请求完成；这与我们先前的描述一致

##### **唤醒**

这时候在 `postman` 上再次访问我们的接口，你可以惊喜的发现，他“复活”了！

```
Actual pid is 48755
48601 Received SIGTERM.
48601 [::]:8000 Listener closed.
48601 Waiting for connections to finish...
48601 Serve() returning...
Server err: accept tcp [::]:8000: use of closed network connection


$ [GIN] 2018/03/15 - 13:00:16 | 200 |     188.096µs |   192.168.111.1 | GET      /api/v1/tags...
```

这就完成了一次正向的流转了

你想想，每次更新发布、或者修改配置文件等，只需要给该进程发送**SIGTERM 信号**，而不需要强制结束应用，是多么便捷又安全的事！

#### 问题

`endless` 热更新是采取创建子进程后，将原进程退出的方式，这点不符合守护进程的要求

### http.Server - Shutdown()

如果你的`Golang >= 1.8`，也可以考虑使用 `http.Server` 的 [Shutdown](https://golang.org/pkg/net/http/#Server.Shutdown) 方法

```go
package main

import (
    "fmt"
    "net/http"
    "context"
    "log"
    "os"
    "os/signal"
    "time"


    "gin-blog/routers"
    "gin-blog/pkg/setting"
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

    go func() {
        if err := s.ListenAndServe(); err != nil {
            log.Printf("Listen: %s\n", err)
        }
    }()

    quit := make(chan os.Signal)
    signal.Notify(quit, os.Interrupt)
    <- quit

    log.Println("Shutdown Server ...")

    ctx, cancel := context.WithTimeout(context.Background(), 5 * time.Second)
    defer cancel()
    if err := s.Shutdown(ctx); err != nil {
        log.Fatal("Server Shutdown:", err)
    }

    log.Println("Server exiting")
}
```

## 小结

在日常的服务中，优雅的重启（热更新）是非常重要的一环。而 `Golang` 在 `HTTP` 服务方面的热更新也有不少方案了，我们应该根据实际应用场景挑选最合适的

## 参考

### 本系列示例代码

- [go-gin-example](https://github.com/EDDYCJY/go-gin-example)

### 拓展阅读

- [manners](https://github.com/braintree/manners)
- [graceful](https://github.com/tylerb/graceful)
- [grace](https://github.com/facebookgo/grace)
- [plugin: new package for loading plugins · golang/go@0cbb12f · GitHub](https://github.com/golang/go/commit/0cbb12f0bbaeb3893b3d011fdb1a270291747ab0)

# 第八章 为它加上Swagger

## 涉及知识点

- Swagger

## 本文目标

一个好的 `API's`，必然离不开一个好的`API`文档，如果要开发纯手写 `API` 文档，不存在的（很难持续维护），因此我们要自动生成接口文档。

## 安装 swag

```
$ go get -u github.com/swaggo/swag/cmd/swag@v1.6.5
```

若 `$GOROOT/bin` 没有加入`$PATH`中，你需要执行将其可执行文件移动到`$GOBIN`下

```
mv $GOPATH/bin/swag /usr/local/go/bin
```

### 验证是否安装成功

检查 $GOBIN 下是否有 swag 文件，如下：

```
$ swag -v
swag version v1.6.5
```

## 安装 gin-swagger

```
$ go get -u github.com/swaggo/gin-swagger@v1.2.0 
$ go get -u github.com/swaggo/files
$ go get -u github.com/alecthomas/template
```

注：若无科学上网，请务必配置 Go modules proxy。

## 初始化

### 编写 API 注释

`Swagger` 中需要将相应的注释或注解编写到方法上，再利用生成器自动生成说明文件

`gin-swagger` 给出的范例：

```go
// @Summary Add a new pet to the store
// @Description get string by ID
// @Accept  json
// @Produce  json
// @Param   some_id     path    int     true        "Some ID"
// @Success 200 {string} string	"ok"
// @Failure 400 {object} web.APIError "We need ID!!"
// @Failure 404 {object} web.APIError "Can not find ID"
// @Router /testapi/get-string-by-int/{some_id} [get]
```

我们可以参照 `Swagger` 的注解规范和范例去编写

```go
// @Summary 新增文章标签
// @Produce  json
// @Param name query string true "Name"
// @Param state query int false "State"
// @Param created_by query int false "CreatedBy"
// @Success 200 {string} json "{"code":200,"data":{},"msg":"ok"}"
// @Router /api/v1/tags [post]
func AddTag(c *gin.Context) {
// @Summary 修改文章标签
// @Produce  json
// @Param id path int true "ID"
// @Param name query string true "ID"
// @Param state query int false "State"
// @Param modified_by query string true "ModifiedBy"
// @Success 200 {string} json "{"code":200,"data":{},"msg":"ok"}"
// @Router /api/v1/tags/{id} [put]
func EditTag(c *gin.Context) {
```

参考的注解请参见 [go-gin-example](https://github.com/EDDYCJY/go-gin-example)。以确保获取最新的 swag 语法

### 路由

在完成了注解的编写后，我们需要针对 swagger 新增初始化动作和对应的路由规则，才可以使用。打开 routers/router.go 文件，新增内容如下：

```go
package routers

import (
	...

	_ "github.com/EDDYCJY/go-gin-example/docs"

	...
)

// InitRouter initialize routing information
func InitRouter() *gin.Engine {
	...
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	...
	apiv1 := r.Group("/api/v1")
	apiv1.Use(jwt.JWT())
	{
		...
	}

	return r
}
```

### 生成

我们进入到`gin-blog`的项目根目录中，执行初始化命令

```
[$ gin-blog]# swag init
2018/03/13 23:32:10 Generate swagger docs....
2018/03/13 23:32:10 Generate general API Info
2018/03/13 23:32:10 create docs.go at  docs/docs.go
```

完毕后会在项目根目录下生成`docs`

```
docs/
├── docs.go
└── swagger
    ├── swagger.json
    └── swagger.yaml
```

我们可以检查 `docs.go` 文件中的 `doc` 变量，详细记载中我们文件中所编写的注解和说明![image](README/37ae10e1714c63899a55d49c19af0860.png)

### 验证

大功告成，访问一下 `http://127.0.0.1:8000/swagger/index.html`， 查看 `API` 文档生成是否正确

![image](README/703b677c6756129c33b5308c1655a35c.png)

## 参考

### 本系列示例代码

- [go-gin-example](https://github.com/EDDYCJY/go-gin-example)





# 第九章 将Golang应用部署到Docker

## 涉及知识点

- Go + Docker

## 本文目标

将我们的 `go-gin-example` 应用部署到一个 Docker 里，你需要先准备好如下东西：

- 你需要安装好 `docker`。
- 如果上外网比较吃力，需要配好镜像源。

## Docker

在这里简单介绍下 Docker，建议深入学习

![image](README/e.png)

Docker 是一个开源的轻量级容器技术，让开发者可以打包他们的应用以及应用运行的上下文环境到一个可移植的镜像中，然后发布到任何支持 Docker 的系统上运行。 通过容器技术，在几乎没有性能开销的情况下，Docker 为应用提供了一个隔离运行环境

- 简化配置
- 代码流水线管理
- 提高开发效率
- 隔离应用
- 快速、持续部署

------

接下来我们正式开始对项目进行 `docker` 的所需处理和编写，每一个大标题为步骤大纲

## Golang

### 一、编写 Dockerfile

在 `go-gin-example` 项目根目录创建 Dockerfile 文件，写入内容

```
FROM golang:latest

ENV GOPROXY https://goproxy.cn,direct
WORKDIR $GOPATH/src/github.com/EDDYCJY/go-gin-example
COPY . $GOPATH/src/github.com/EDDYCJY/go-gin-example
RUN go build .

EXPOSE 8000
ENTRYPOINT ["./go-gin-example"]
```

#### 作用

`golang:latest` 镜像为基础镜像，将工作目录设置为 `$GOPATH/src/go-gin-example`，并将当前上下文目录的内容复制到 `$GOPATH/src/go-gin-example` 中

在进行 `go build` 编译完毕后，将容器启动程序设置为 `./go-gin-example`，也就是我们所编译的可执行文件

注意 `go-gin-example` 在 `docker` 容器里编译，并没有在宿主机现场编译

#### 说明

Dockerfile 文件是用于定义 Docker 镜像生成流程的配置文件，文件内容是一条条指令，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建；这些指令应用于基础镜像并最终创建一个新的镜像

你可以认为用于快速创建自定义的 Docker 镜像

**1、 FROM**

指定基础镜像（必须有的指令，并且必须是第一条指令）

**2、 WORKDIR**

格式为 `WORKDIR` <工作目录路径>

使用 `WORKDIR` 指令可以来**指定工作目录**（或者称为当前目录），以后各层的当前目录就被改为指定的目录，如果目录不存在，`WORKDIR` 会帮你建立目录

**3、COPY**

格式：

```
COPY <源路径>... <目标路径>
COPY ["<源路径1>",... "<目标路径>"]
```

`COPY` 指令将从构建上下文目录中 <源路径> 的文件/目录**复制**到新的一层的镜像内的 <目标路径> 位置

**4、RUN**

用于执行命令行命令

格式：`RUN` <命令>

**5、EXPOSE**

格式为 `EXPOSE` <端口 1> [<端口 2>…]

`EXPOSE` 指令是**声明运行时容器提供服务端口，这只是一个声明**，在运行时并不会因为这个声明应用就会开启这个端口的服务

在 Dockerfile 中写入这样的声明有两个好处

- 帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射
- 运行时使用随机端口映射时，也就是 `docker run -P` 时，会自动随机映射 `EXPOSE` 的端口

**6、ENTRYPOINT**

`ENTRYPOINT` 的格式和 `RUN` 指令格式一样，分为两种格式

- `exec` 格式：

```
<ENTRYPOINT> "<CMD>"
```

- `shell` 格式：

```
ENTRYPOINT [ "curl", "-s", "http://ip.cn" ]
```

`ENTRYPOINT` 指令是**指定容器启动程序及参数**

### 二、构建镜像

```
go-gin-example` 的项目根目录下**执行** `docker build -t gin-blog-docker .
```

该命令作用是创建/构建镜像，`-t` 指定名称为 `gin-blog-docker`，`.` 构建内容为当前上下文目录

```
$ docker build -t gin-blog-docker .
Sending build context to Docker daemon 96.39 MB
Step 1/6 : FROM golang:latest
 ---> d632bbfe5767
Step 2/6 : WORKDIR $GOPATH/src/github.com/EDDYCJY/go-gin-example
 ---> 56294f978c5d
Removing intermediate container e112997b995d
Step 3/6 : COPY . $GOPATH/src/github.com/EDDYCJY/go-gin-example
 ---> 3b60960120cf
Removing intermediate container 63e310b3f60c
Step 4/6 : RUN go build .
 ---> Running in 52648a431450
go: downloading github.com/gin-gonic/gin v1.3.0
go: downloading github.com/go-ini/ini v1.32.1-0.20180214101753-32e4be5f41bb
go: downloading github.com/swaggo/gin-swagger v1.0.1-0.20190110070702-0c6fcfd3c7f3
...
 ---> 7bfbeb301fea
Removing intermediate container 52648a431450
Step 5/6 : EXPOSE 8000
 ---> Running in 98f5b387d1bb
 ---> b65bd4076c65
Removing intermediate container 98f5b387d1bb
Step 6/6 : ENTRYPOINT ./go-gin-example
 ---> Running in c4f6cdeb667b
 ---> d8a109c7697c
Removing intermediate container c4f6cdeb667b
Successfully built d8a109c7697c
```

### 三、验证镜像

查看所有的镜像，确定刚刚构建的 `gin-blog-docker` 镜像是否存在

```
$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED              SIZE
gin-blog-docker         latest              d8a109c7697c        About a minute ago   946 MB
docker.io/golang        latest              d632bbfe5767        8 days ago           779 MB
...
```

### 四、创建并运行一个新容器

执行命令 `docker run -p 8000:8000 gin-blog-docker`

```
$ docker run -p 8000:8000 gin-blog-docker
dial tcp 127.0.0.1:3306: connect: connection refused
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

...
Actual pid is 1
```

运行成功，你以为大功告成了吗？

你想太多了，仔细看看控制台的输出了一条错误 `dial tcp 127.0.0.1:3306: connect: connection refused`

我们研判一下，发现是 `Mysql` 的问题，接下来第二项我们将解决这个问题

## Mysql



```bash
docker exec -it mysql bash
```



### 一、拉取镜像

从 `Docker` 的公共仓库 `Dockerhub` 下载 `MySQL` 镜像（国内建议配个镜像）

```
$ docker pull mysql
```

### 二、创建并运行一个新容器

运行 `Mysql` 容器，并设置执行成功后返回容器 ID

```
$ docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=rootroot -d mysql
8c86ac986da4922492934b6fe074254c9165b8ee3e184d29865921b0fef29e64
```

#### 连接 Mysql

初始化的 `Mysql` 应该如图

![image](README/5ab4caab04cf1.png)

## Golang + Mysql

### 一、删除镜像

由于原本的镜像存在问题，我们需要删除它，此处有几种做法

- 删除原本有问题的镜像，重新构建一个新镜像
- 重新构建一个不同 `name`、`tag` 的新镜像

删除原本的有问题的镜像，`-f` 是强制删除及其关联状态

若不执行 `-f`，你需要执行 `docker ps -a` 查到所关联的容器，将其 `rm` 解除两者依赖关系

```
$ docker rmi -f gin-blog-docker
Untagged: gin-blog-docker:latest
Deleted: sha256:d8a109c7697c3c2d9b4de7dbb49669d10106902122817b6467a031706bc52ab4
Deleted: sha256:b65bd4076c65a3c24029ca4def3b3f37001ff7c9eca09e2590c4d29e1e23dce5
Deleted: sha256:7bfbeb301fea9d8912a4b7c43e4bb8b69bdc57f0b416b372bfb6510e476a7dee
Deleted: sha256:3b60960120cf619181c1762cdc1b8ce318b8c815e056659809252dd321bcb642
Deleted: sha256:56294f978c5dfcfa4afa8ad033fd76b755b7ecb5237c6829550741a4d2ce10bc
```

### 二、修改配置文件

将项目的配置文件 `conf/app.ini`，内容修改为

```ini
#debug or release
RUN_MODE = debug

[app]
PAGE_SIZE = 10
JWT_SECRET = 233

[server]
HTTP_PORT = 8000
READ_TIMEOUT = 60
WRITE_TIMEOUT = 60

[database]
TYPE = mysql
USER = root
PASSWORD = rootroot
HOST = mysql:3306
NAME = blog
TABLE_PREFIX = blog_
```

### 三、重新构建镜像

重复先前的步骤，回到 `gin-blog` 的项目根目录下**执行** `docker build -t gin-blog-docker .`

### 四、创建并运行一个新容器

## 关联

Q：我们需要将 `Golang` 容器和 `Mysql` 容器关联起来，那么我们需要怎么做呢？

A：增加命令 `--link mysql:mysql` 让 `Golang` 容器与 `Mysql` 容器互联；通过 `--link`，**可以在容器内直接使用其关联的容器别名进行访问**，而不通过 IP，但是`--link`只能解决单机容器间的关联，在分布式多机的情况下，需要通过别的方式进行连接

## 运行

执行命令 `docker run --link mysql:mysql -p 8000:8000 gin-blog-docker`

```
$ docker run --link mysql:mysql -p 8000:8000 gin-blog-docker
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)
...
Actual pid is 1
```

## 结果

检查启动输出、接口测试、数据库内数据，均正常；我们的 `Golang` 容器和 `Mysql` 容器成功关联运行，大功告成 :)

------

## Review

### 思考

虽然应用已经能够跑起来了

但如果对 `Golang` 和 `Docker` 有一定的了解，我希望你能够想到至少 2 个问题

- 为什么 `gin-blog-docker` 占用空间这么大？（可用 `docker ps -as | grep gin-blog-docker` 查看）
- `Mysql` 容器直接这么使用，数据存储到哪里去了？

### 创建超小的 Golang 镜像

Q：第一个问题，为什么这么镜像体积这么大？

A：`FROM golang:latest` 拉取的是官方 `golang` 镜像，包含 Golang 的编译和运行环境，外加一堆 GCC、build 工具，相当齐全

这是有问题的，**我们可以不在 Golang 容器中现场编译的**，压根用不到那些东西，我们只需要一个能够运行可执行文件的环境即可

#### 构建 Scratch 镜像

Scratch 镜像，简洁、小巧，基本是个空镜像

##### 一、修改 Dockerfile

```
FROM scratch

WORKDIR $GOPATH/src/github.com/EDDYCJY/go-gin-example
COPY . $GOPATH/src/github.com/EDDYCJY/go-gin-example

EXPOSE 8000
CMD ["./go-gin-example"]
```

##### 二、编译可执行文件

```
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o go-gin-example .
```

编译所生成的可执行文件会依赖一些库，并且是动态链接。在这里因为使用的是 `scratch` 镜像，它是空镜像，因此我们需要将生成的可执行文件静态链接所依赖的库

##### 三、构建镜像

```
$ docker build -t gin-blog-docker-scratch .
Sending build context to Docker daemon 133.1 MB
Step 1/5 : FROM scratch
 --->
Step 2/5 : WORKDIR $GOPATH/src/github.com/EDDYCJY/go-gin-example
 ---> Using cache
 ---> ee07e166a638
Step 3/5 : COPY . $GOPATH/src/github.com/EDDYCJY/go-gin-example
 ---> 1489a0693d51
Removing intermediate container e3e9efc0fe4d
Step 4/5 : EXPOSE 8000
 ---> Running in b5630de5544a
 ---> 6993e9f8c944
Removing intermediate container b5630de5544a
Step 5/5 : CMD ./go-gin-example
 ---> Running in eebc0d8628ae
 ---> 5310bebeb86a
Removing intermediate container eebc0d8628ae
Successfully built 5310bebeb86a
```

注意，假设你的 Golang 应用没有依赖任何的配置等文件，是可以直接把可执行文件给拷贝进去即可，其他都不必关心

这里可以有好几种解决方案

- 依赖文件统一管理挂载
- go-bindata 一下

…

因此这里如果**解决了文件依赖的问题**后，就不需要把目录给 `COPY` 进去了

##### 四、运行

```
$ docker run --link mysql:mysql -p 8000:8000 gin-blog-docker-scratch
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /auth                     --> github.com/EDDYCJY/go-gin-example/routers/api.GetAuth (3 handlers)
...
```

成功运行，程序也正常接收请求

接下来我们再看看占用大小，执行 `docker ps -as` 命令

```
$ docker ps -as
CONTAINER ID        IMAGE                     COMMAND                  ...         SIZE
9ebdba5a8445        gin-blog-docker-scratch   "./go-gin-example"       ...     0 B (virtual 132 MB)
427ee79e6857        gin-blog-docker           "./go-gin-example"       ...     0 B (virtual 946 MB)
```

从结果而言，占用大小以`Scratch`镜像为基础的容器完胜，完成目标

### Mysql 挂载数据卷

倘若不做任何干涉，在每次启动一个 `Mysql` 容器时，数据库都是空的。另外容器删除之后，数据就丢失了（还有各类意外情况），非常糟糕！

#### 数据卷

数据卷 是被设计用来持久化数据的，它的生命周期独立于容器，Docker 不会在容器被删除后自动删除 数据卷，并且也不存在垃圾回收这样的机制来处理没有任何容器引用的 数据卷。如果需要在删除容器的同时移除数据卷。可以在删除容器的时候使用 `docker rm -v` 这个命令

数据卷 是一个可供一个或多个容器使用的特殊目录，它绕过 UFS，可以提供很多有用的特性：

- 数据卷 可以在容器之间共享和重用
- 对 数据卷 的修改会立马生效
- 对 数据卷 的更新，不会影响镜像
- 数据卷 默认会一直存在，即使容器被删除

> 注意：数据卷 的使用，类似于 Linux 下对目录或文件进行 mount，镜像中的被指定为挂载点的目录中的文件会隐藏掉，能显示看的是挂载的 数据卷。

#### 如何挂载

首先创建一个目录用于存放数据卷；示例目录 `/data/docker-mysql`，注意 `--name` 原本名称为 `mysql` 的容器，需要将其删除 `docker rm`

```
$ docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=rootroot -v /data/docker-mysql:/var/lib/mysql -d mysql
54611dbcd62eca33fb320f3f624c7941f15697d998f40b24ee535a1acf93ae72
```

创建成功，检查目录 `/data/docker-mysql`，下面多了不少数据库文件

#### 验证

接下来交由你进行验证，目标是创建一些测试表和数据，然后删除当前容器，重新创建的容器，数据库数据也依然存在（当然了数据卷指向要一致）

我已验证完毕，你呢？

## 参考

### 本系列示例代码

- [go-gin-example](https://github.com/EDDYCJY/go-gin-example)

### 书籍

- [Docker —— 从入门到实践](https://www.gitbook.com/book/yeasy/docker_practice/details)