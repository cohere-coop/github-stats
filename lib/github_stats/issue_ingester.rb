require_relative 'github_client'
module GithubStats
  # Retrieves issues from Github and upserts them into the database.
  class IssueIngester
    attr_accessor :search_string, :options

    def initialize(search_string, options)
      self.search_string = search_string
      self.options = options
    end

    def ingest
      return unless options[:ingest]
      github.search_issues(search_string).items.each(&method(:insert_or_update))
    end

    private def insert_or_update(result)
      issue = issues.first(github_id: result[:id])
      started_at = started_at(result)
      return insert(result, started_at: started_at) unless issue
      return update(issue, result, started_at: started_at) if issue[:closed_at] != result[:closed_at] ||
                                                              issue[:created_at] != result[:created_at] ||
                                                              issue[:started_at] != started_at
    end

    private def started_at(result)
      starting_event = result.rels[:events].get.data.find do |event|
        next unless event[:event] == 'labeled'
        (event[:label] || {})[:name] == 'in-progress'
      end
      starting_event.nil? ? nil : starting_event[:created_at]
    end

    private def update(issue, result, started_at:)
      issue.update(closed_at: result[:closed_at],
                   created_at: result[:created_at],
                   started_at: started_at)
    end

    private def insert(result, started_at:)
      issues.insert(search_string: search_string, github_id: result[:id],
                    closed_at: result[:closed_at],
                    created_at: result[:created_at],
                    started_at: started_at,
                    url: result[:url])
    end

    private def issues
      db.issues.where(search_string: search_string)
    end

    private def db
      @db ||= Database.new(options)
    end

    private def github
      @github ||= GithubClient.new(options)
    end
  end
end
