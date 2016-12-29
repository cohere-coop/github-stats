module GithubStats
  # Main entrance point to the command line tool.
  # Sets defaults and parses options etc.
  class CLI
    def self.run(search_string, options)
      new(search_string, options).run
    end

    attr_accessor :search_string, :options

    def initialize(remaining_args, options)
      @search_string = remaining_args.join(' ')
      options[:database_url] ||= "sqlite://#{home_dir}/db.sqlite"
      options[:report_type] ||= 'closed_by_week'
      options[:ingest] = true unless options.key?(:ingest)
      @options = options
    end

    def run
      setup_db
      ingest
      results
    end

    private def setup_db
      Database.new(options).setup
    end

    private def home_dir
      return if @home_dir
      @home_dir = File.join(Dir.home, '.github-stats')
      Dir.mkdir(@home_dir) unless Dir.exist?(@home_dir)
      @home_dir
    end

    private def ingest
      IssueIngester.new(search_string, options).ingest
    end

    private def report
      Reports.for(options[:report_type]).new(search_string, options)
    end

    private def results
      CommaSeperatedLinePerResultResultsView.new(report.results)
    end

    # Transforms a result set into a space-seperated table the results hash
    # keys becoming the table headers and line breaks between rows.
    class CommaSeperatedLinePerResultResultsView
      attr_accessor :results
      def initialize(results)
        self.results = results
      end

      def fields
        results.keys
      end

      def to_s
        fields.join(',') + "\n" + results.map do |result|
          fields.map(&result.method(:fetch)).join(',')
        end.join("\n")
      end
    end
  end
end
