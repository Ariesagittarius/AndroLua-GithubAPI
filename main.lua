require "import"

--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
Github = require("github.Github")

Github:init {
    "SimpleIssue",
    "SimplePull",
    "Searcher",
    "GithubUser",
    "IssuesCollection",
    "PullsCollection",
    "Repository"
}
    :token("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")

Github:search()
    :keyword("material-components")
    :filter("language", "java")
    :start(function(data)

        local repository =
        Github:repo(data.items[1].full_name)
            :config(function(data)
                print("Repository name", data.owner.login)
                GithubUser:new(data.owner.login)
                    :config(function(data)
                        print(
                            "Repository owner's following number",
                            tointeger(data.followers)
                        )
                    end)
            end)

        repository
            :issues()
            :state(IssuesCollection.STATE_OPEN)
            :page(1)
            :get(function(data)
                print("Issue Page 1 :Total", #data)
                SimpleIssue:new {
                    id = data[1].number,
                    repo = repository.name,
                }
                    :config(function(data)
                        print("First Issue\n", data.title)
                    end)
            end)

        repository
            :pulls()
            :page(2)
            :get(function(data)
                print("Pull Requests Page 2 :Total", #data)
                SimplePull:new {
                    id = data[2].number,
                    repo = repository.name,
                }
                    :config(function(data)
                        print("Second Pull\n", data.title)
                    end)
            end)

    end)
