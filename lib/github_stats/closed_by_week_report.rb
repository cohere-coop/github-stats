require_relative 'database'
module GithubStats
  # Provides week-by-week breakdown of issues closed, grouped by week
  # with a 3 week moving average.
  class ClosedByWeekReport
    attr_accessor :search_string, :options

    def initialize(search_string, options)
      self.search_string = search_string
      self.options = options
    end

    def results
      results = with_velocity(with_week_closed(with_qty(issues)))
      Results.new(results)
    end

    private def with_velocity(issues)
      closed_two_weeks_ago = 0
      closed_last_week = 0
      issues.map do |issue|
        issue[:velocity] = average(closed_two_weeks_ago, closed_last_week,
                                   issue[:qty])
        closed_two_weeks_ago = closed_last_week
        closed_last_week = issue[:qty]
        issue
      end
    end

    private def average(*numbers)
      numbers.reduce(:+) / numbers.length
    end

    private def with_qty(dataset)
      dataset.select { count(:id).as qty }
    end

    private def with_week_closed(dataset)
      dataset.select_append { strftime('%Y-%W', closed_at).as(week_closed) }
        .group_by(:week_closed)
    end

    private def issues
      db.issues.where(search_string: search_string).where { closed_at !~ nil }
    end

    private def db
      @db ||= Database.new(options)
    end

    # Provides enumerable access to the results
    class Results
      attr_accessor :data
      extend Forwardable
      def_delegators :data, :each, :map

      def initialize(data)
        self.data = data
      end

      def keys
        [:week_closed, :qty, :velocity]
      end
    end
  end
end
