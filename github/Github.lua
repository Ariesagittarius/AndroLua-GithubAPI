local Repository = require "github.internal.Repository"
local Searcher   = require "github.internal.Searcher"
local User       = require "github.internal.GithubUser"

local Github = {
    GLOBAL_TOKEN = "",
}
---comment
---@param params table
function Github:init(params)
    import "cjson"
    import "com.androlua.Http"
    for _, value in ipairs(params) do
        _ENV["value"] = import("github.internal." .. value)
    end
    setmetatable({}, self)
    return self
end

---@param token string
function Github:token(token)
    Github.GLOBAL_TOKEN = token
    return self
end

function Github:repo(repo_name)
    return Repository:open(repo_name)
end

function Github:search(params)
    return Searcher:create(params)
end

function Github:user(login)
    return User:new(login)
end

return Github
