package routers

import (
	"github.com/gin-gonic/gin"
	
	"github.com/panda8z/go-gin-example/middleware/jwt"
	"github.com/panda8z/go-gin-example/pkg/setting"
	"github.com/panda8z/go-gin-example/routers/api"
	v1 "github.com/panda8z/go-gin-example/routers/api/v1"
)

// InitRouter 初始化路由配置
// 定义v1路由组
func InitRouter() *gin.Engine {
	// 创建路由
	r := gin.New()

	// 使用日志中间件
	r.Use(gin.Logger())

	// 使用自动恢复现场中间件
	r.Use(gin.Recovery())

	// 设置运行模式 debug release test
	gin.SetMode(setting.RunMode)

	// 添加一个认证路由
	r.GET("/auth", api.GetAuth)

	// v1路由组
	apiv1 := r.Group("/api/v1")
	apiv1.Use(jwt.JWT())
	{
		//获取标签列表
		apiv1.GET("/tags", v1.GetTags)
		//新建标签
		apiv1.POST("/tags", v1.AddTag)
		//编辑指定标签
		apiv1.PUT("/tags/:id", v1.EditTag)
		//删除指定标签
		apiv1.DELETE("/tags/:id", v1.DeleteTag)

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
