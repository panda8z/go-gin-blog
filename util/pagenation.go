package util

import (
	"github.com/gin-gonic/gin"
	"github.com/unknwon/com"

	"github.com/EDDYCJY/go-gin-example/pkg/setting"
)

// GetPage 解析并获取URL传过来的页面参数
func GetPage(c *gin.Context) int {
	result := 0
	page, _ := com.StrTo(c.Query("page")).Int()
	if page > 0 {
		result = (page - 1) * setting.PageSize
	}

	return result
}
