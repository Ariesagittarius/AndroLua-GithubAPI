# AndroLua-GithubAPI

> 一套简易的接口，用以在AndroLua快速发起Github请求；

本项目使用Github官方API，较之网页访问速度有较大提升

在本应用中填写`Personal access token`将会大大提高使用体验，不填写token时，您只拥有一个小时内的60次访问机会，填写之后这一数字会涨到5000.

[了解如何获取](personal_token.md)


## How to use

```lua
--导入Github.lua文件
require("github.Github")

--- 导入需要的模块作为全局变量
Github:init {
    "SimpleIssue",
    "SimplePull",
    "Searcher",
    "User",
    "IssuesCollection",
    "PullsCollection",
    "Repository"
}

--- 初始化 Personal access token
    :token("<your token>")
```

## Api

### 发起搜索

`Searcher.create()`等同于`Github:search()`

``` lua
--- 一步到位
Github:search {
    type = "repositories",
    keyword = "material-components",
    page = 1,
    per_page = 50,
}
    :start(function(data)
        print(#data.items)
    end)

--- 链式调用
Github:search()
    :keyword("material-components") --- 搜索关键词
    :page(1)                        --- 页面索引
    :per_page(50)                   --- 单页最大获取量
    :filter("language","java")      --- 过滤器 (也可用 rule() 写规则表达式)
    :start(callback)               --- 发起搜索
``` 

### 获取仓库
`Repository:open()`等同于`Github:repo()`

```lua
local repository = Github:repo(repo_name[[仓库全名]])

    repository:config(callback[[回调函数，唯一参数是table格式的返回数据，下同]])
        :languages(callback[[回调函数]])
        :readme(callback[[回调函数]])
        :releases(callback[[回调函数]])

    repository:issues()         --> IssuesCollection
    repository:pulls()          --> PullsCollection
    repository:get_zipball()    --> string 压缩包链接
``` 

### 获取议题


```lua
--- 单议题
SimpleIssue:new{
    repo="repo_name",       -- 仓库名
    id=1                    -- 议题id
    }
    :config(                -- 获取议题信息
        function(data)
            print(data.body)-- 议题内容
        end
    )
    :comments(callback)
    :events(callback)

--- 多议题
IssuesCollection:open(repo_name[[仓库全名]])
    :state(IssuesCollection.STATE_OPEN) -- 议题状态，默认为 STATE_OPEN
    :page(1)                            -- 页面索引，默认为 1
    :all()                              -- 获取所有议题，与 page() 相互抵消
    :get(callback[[回调函数]])           -- 发送请求
``` 

### 拉取请求


``` lua
--- 单拉取请求
SimplePull:new{
    repo="repo_name",       -- 仓库名
    id=1                    -- 拉取请求 id
}
    :comments(callback)
    :reviews(callback)
    :events(callback)
    :commits(callback)

--- 多拉取请求
PullsCollection:open(repo_name[[仓库全名]])
    :page(1)                           -- 页面索引，默认为 1
    :all()                             -- 获取所有拉取请求，与 page() 相互抵消
    :get(callback[[回调函数]])          -- 发送请求    
```

### 用户信息

`GithubUser:new()`等同于`Github:user()`

``` lua
Github:user("Ariesagittarius")
    :config(function(data)  ---个人信息
        print(data.login)
    end)
    :starred()              --- 星标仓库
    :repos()                --- 个人仓库
    :following()            --- 关注的人
    :followers()            --- 关注他的人
```
