module GithubStats
  # Encapsulates github interactions so we can inject boring defaults and
  # auto-paginate and potentially throttle or whatever.
  class GithubClient
    attr_accessor :octokit

    def initialize(options)
      self.octokit = Octokit::Client.new(access_token:
                                          options[:github_access_token],
                                         auto_paginate: true)
    end

    def search_issues(query, options = { per_page: 100 })
      octokit.search_issues(query, options)
    end
  end
end
