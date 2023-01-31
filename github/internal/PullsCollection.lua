
local PullsCollection = {
    base_url = "https://api.github.com/repos/%s/pulls",
}

---@param repo_name string 仓库名称
---@return self table
function PullsCollection:open(repo_name)
    setmetatable({}, self)
    self.issue_url = string.format(self.base_url, repo_name)
    return self
end

---@param pageIndex number
---@return self table
function PullsCollection:page(pageIndex)
    self.page_number = pageIndex
    self.is_all = false
    return self
end

---@return self table
function PullsCollection:all()
    self.is_all = true
    return self
end

function PullsCollection:get(callback)

    local function get_page(self,index, callback)
        local token = {
            Authorization = Github.GLOBAL_TOKEN
        }
        local url = string.format("%s?page=%d", self.issue_url, self.page_index)
        ---@param code number 状态码
        ---@param html string 网页HTML内容
        Http.get(url, nil, nil, token, function(code, html)
            if code == 200 then
                callback(self,cjson.decode(html))
            end
        end)
    end
    local function internal_callback(self,data)
        if not self.is_all then
            self.call(data)
        elseif #data == 0 then
            self.call(self.issues)
        else
            for _,value in pairs(data) do
                table.insert(self.issues, value)
            end
            self.page_index = self.page_index + 1
            get_page(self,self.page_number, internal_callback)        
        end
    end
    self.issues = {}
    self.page_index = self.is_all and 1 or self.page_number
    self.call = callback
    get_page(self,self.page_index, internal_callback)
    
    return self
end

return PullsCollection
