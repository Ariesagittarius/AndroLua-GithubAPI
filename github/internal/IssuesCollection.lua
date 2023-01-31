
local IssuesCollection = {
    base_url = "https://api.github.com/repos/%s/issues",
    state = "open",
    STATE_OPEN = 1,
    STATE_CLOSED = 0,
}

---@param repo_name string 仓库名称
---@return self table
function IssuesCollection:open(repo_name)
    setmetatable({}, self)
    self.issue_url = string.format(self.base_url, repo_name)
    return self
end

---@param state integer
---@return self table
function IssuesCollection:state(state)
    if state == self.STATE_CLOSED then
        self.state = "closed"
    elseif state == self.STATE_OPEN then
        self.state = "open"
    end
    return self
end

---@param pageIndex integer
---@return self table
function IssuesCollection:page(pageIndex)
    self.page_number = pageIndex
    self.is_all = false
    return self
end

---@return self table
function IssuesCollection:all()
    self.is_all = true
    return self
end

function IssuesCollection:get(callback)

    local function get_page(self, index, callback)
        local token = {
            Authorization = Github.GLOBAL_TOKEN           
        }
        local url = string.format("%s?page=%d&state=%s", self.issue_url, self.page_index, self.state)
        ---@param code number 状态码
        ---@param html string 网页HTML内容
        Http.get(url, nil, nil, token, function(code, html)
            if code == 200 then
                callback(self, cjson.decode(html))
            end
        end)
    end

    local function internal_callback(self, data)
        if not self.is_all then
            self.call(data)
        elseif #data == 0 then
            self.call(self.issues)
        else
            for _, value in pairs(data) do
                table.insert(self.issues, value)
            end
            self.page_index = self.page_index + 1
            get_page(self, self.page_number, internal_callback)
        end
    end

    self.issues = {}
    self.page_index = self.is_all and 1 or (self.page_number or 1)
    self.call = callback
    get_page(self, self.page_index, internal_callback)

    return self
end

return IssuesCollection