local IssuesCollection = require "github.internal.IssuesCollection"
local PullsCollection  = require "github.internal.PullsCollection"

local Repository = {
    base_url = "https://api.github.com/repos/%s",
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

---@param name string
---@return table
function Repository:open(name)
    setmetatable({}, self)
    self.name = name
    self.repo_url = string.format(self.base_url, self.name)
    self.languages_url = self.repo_url .. "/languages"
    self.releases_url = self.repo_url .. "/releases"
    self.readme_url = self.repo_url .. "/readme"
    self.zipball_url = self.repo_url .. "/zipball"
    return self
end

---@param callback function
---@return table
function Repository:config(callback)
    self.get(self.repo_url, callback)
    return self
end

---@param callback function
---@return table
function Repository:languages(callback)
    self.get(self.languages_url, callback)
    return self
end

---@param callback function
---@return table
function Repository:readme(callback)
    self.get(self.readme_url, callback)
    return self
end

---@param callback function
---@return table
function Repository:releases(callback)
    self.get(self.releases_url, callback)
    return self
end

---@return table IssuesCollection
function Repository:issues()
    return IssuesCollection:open(self.name)
end

---@return table PullsCollection
function Repository:pulls()
    return PullsCollection:open(self.name)
end

---@param callback function
---@return string
function Repository:get_zipball(callback)
    return self.zipball_url
end

return Repository
