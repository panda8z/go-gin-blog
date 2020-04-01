package logging

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"runtime"
)

// 定义日志级别
type Level int

// 定义必要字段
var (
	// 全局持有的日志文件
	F *os.File

	// 默认前缀
	DefaultPrefix = ""
	// 默认读取深度2
	DefaultCallerDepth = 2

	// 标准库日志接口
	logger *log.Logger
	// 日志前缀
	logPrefix = ""
	// 便捷级别字段， 对应日志级别常量
	levelFlags = []string{"DEBUG", "INFO", "WARN", "ERROR", "FATAL"}
)

// 定义日志级别常量
const (
	DEBUG Level = iota
	INFO
	WARNING
	ERROR
	FATAL
)

// 初始化本地全局变量 分别是日志文件，全局logger
func init() {
	filePath := getLogFileFullPath()
	F = openLogFile(filePath)

	// 使用标准库log，New 一个日志实例，重定向到文件
	logger = log.New(F, DefaultPrefix, log.LstdFlags)
}

// 1. 设置日志级别
// 2. 用标准库logger打印日志
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
