module GithubStats
  # Encapsulates github interactions so we can inject boring defaults and
  # auto-paginate and potentially throttle or whatever.
  class GithubClient
    attr_accessor :octokit

    def initialize(options)
      self.octokit = Octokit::Client.new(access_token:
                                          options[:github_access_token])
    end

    def search_issues(query, options = { per_page: 100 })
      octokit.search_issues(query, options)
      Response.new(self)
    end

    def last_response
      octokit.last_response
    end

    # Auto-paginate!
    class Response
      attr_reader :client
      def initialize(client)
        @client = client
      end

      def each(&block)
        last_response = client.last_response
        loop do
          last_response.data.items.each(&block)
          last_response = last_response.rels[:next].get
          break if last_response.rels[:next].nil?
        end
      end
    end
  end
end
