
local GithubUser = {
    name = "User",
    base_url = "https://api.github.com/users/%s",
    starred_url = "https://api.github.com/users/%s/starred",
    repos_url = "https://api.github.com/users/%s/repos",
    followers_url = "https://api.github.com/users/%s/followers",
    following_url = "https://api.github.com/users/%s/following",
    ---@param url string 请求的链接
    ---@param callback function 回调函数
    get = function(url, callback)
        local header = {
            Authorization = Github.GLOBAL_TOKEN,
        }
        Http.get(url, nil, nil, header, function(code, html)
            if code == 200 then
                callback(cjson.decode(html))
            end
        end)
    end
}

---@param login string user's name
function GithubUser:new(login)
    setmetatable({}, self)
    self.name = login
    return self
end

---@param callback function 回调函数
function GithubUser:config(callback)
    local url = string.format(self.base_url, self.name)
    self.get(url, callback)
    return self
end

---@param callback function 回调函数
function GithubUser:starred(callback)
    local url = string.format(self.starred_url, self.name)
    self.get(url, callback)
end

---@param callback function 回调函数
function GithubUser:repos(callback)
    local url = string.format(self.repos_url, self.name)
    self.get(url, callback)
    return self
end

---@param callback function 回调函数
function GithubUser:followers(callback)
    local url = string.format(self.followers_url, self.name)
    self.get(url, callback)
    return self
end

---@param callback function 回调函数
function GithubUser:following(callback)
    local url = string.format(self.following_url, self.name)
    self.get(url, callback)
    return self
end

return GithubUser
