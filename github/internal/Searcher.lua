local Searcher = {
    base_url = "https://api.github.com/search/%s?q=%s%s&page=%s&per_page=%s",
    _search = function(url, callback)
        local token = {
            Authorization = Github.GLOBAL_TOKEN
        }
        Http.get(url, nil, nil, token, function(code, html)
            if code == 200 then
                callback(cjson.decode(html))
            end
        end)
    end,
    _type = "repositories",
    _page = "1",
    _per_page = "30",
    filter_rule = "",
}

---@param params table 参数表
---@return self table  `Searcher`对象
function Searcher:create(params)
    setmetatable({}, self)
    if params then
        self._type = params.type
        self._keyword = params.keyword
        self._page = tostring(params.page)
        self._per_page = tostring(params.per_page)
    end
    return self
end

---@param keyword string 搜索关键词（可使用`rule`方法替代）
---@return table
function Searcher:keyword(keyword)
    self._keyword = keyword
    return self
end

---@param type string 搜索类型
---@return table
function Searcher:type(type)
    self._type = type
    return self
end

---@param index integer 页数索引
---@return table
function Searcher:page(index)
    self._page = tostring(index)
    return self
end

---@param count integer 每页最大返回数量(<=100)
---@return table
function Searcher:per_page(count)
    self._per_page = tostring(count)
    return self
end

---@param rule string 搜索规则
---@return table
function Searcher:rule(rule)
    self.filter_rule = rule
    return self
end

---@param rule_key string 过滤器索引
---@param value string 过滤器值
---@return table
function Searcher:filter(rule_key, value)
    self.filter_rule = string.format("%s+%s:%s", self.filter_rule, rule_key, value)
    return self
end

---@param callback function 回调函数
function Searcher:start(callback)
    local search_data = {
        self._type,
        self._keyword,
        self.filter_rule,
        self._page,
        self._per_page
    }
    for i = 1, 6 do
        search_data[i] = search_data[i] or ""
    end
    local api_url = string.format(
        self.base_url,
        table.unpack(search_data)
    )
    self._search(api_url, callback)
end

return Searcher
