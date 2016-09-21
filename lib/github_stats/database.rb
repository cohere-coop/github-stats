Sequel.database_timezone = :utc
Sequel.application_timezone = :utc
module GithubStats
  # Encapsulates database bits and bobs and tiddles.
  class Database
    attr_accessor :options, :adapter
    def initialize(options)
      self.options = options
    end

    def adapter
      @adapter ||= Sequel.connect(database_url)
    end

    def issues
      adapter[:issues]
    end

    def setup
      return if setup?
      create_issues
      create_events
    end

    private def setup?
      File.exist?(URI.parse(database_url).path)
    end

    private def create_issues
      adapter.create_table :issues do
        primary_key :id
        String :url
        String :repo
        String :search_string
        Integer :github_id
        Integer :number
        DateTime :closed_at
        DateTime :created_at
        DateTime :started_at
      end
    end

    private def create_events
      adapter.create_table :events do
        primary_key :id
        foreign_key :issue_id, :issues, on_delete: :cascade
        DateTime :created_at
        String :type
      end
    end

    private def create_stages
      adapter.create_table :stages do
        primary_key :id
        Integer :issue_id
        String :name
        DateTime :entered_at
        DateTime :left_at
      end
    end

    private def database_url
      options[:database_url]
    end
  end
end
