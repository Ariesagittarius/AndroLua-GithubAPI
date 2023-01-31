
local SimpleIssue = {
    base_url = "https://api.github.com/repos/%s/issues/%s",
    ---@param url string
    ---@param callback function
    get = function(url, callback)
        local token = {
            Authorization = Github.GLOBAL_TOKEN
        }
        Http.get(url, nil, nil, token, function(code, html)
            if code == 200 then
                callback(cjson.decode(html))
            end
        end)
    end
}

---@param params table
---@return self table
function SimpleIssue:new(params)
    setmetatable({}, self)
    self.id = params.id
    self.repo = params.repo
    self.final_url = string.format(self.base_url, self.repo, self.id)
    self.comments_url = self.final_url .. "/comments"
    self.events_url = self.final_url .. "/events"
    return self
end

---@param callback function
---@return self table
function SimpleIssue:config(callback)
    self.get(self.final_url, callback)
    return self
end

---@param callback function
---@return self table
function SimpleIssue:comments(callback)
    self.get(self.comments_url, callback)
    return self
end

---@param callback function
---@return self table
function SimpleIssue:events(callback)
    self.get(self.events_url, callback)
    return self
end

return SimpleIssue
