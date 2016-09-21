module GithubStats
  module Reports
    module Report
      def initialize(search_string, options)
        self.search_string = search_string
        self.options = options
      end

      private def with_moving_average(label, weeks)
        closed_two_weeks_ago = 0
        closed_last_week = 0
        weeks.map do |week|
          week[label] = average(closed_two_weeks_ago, closed_last_week,
                                week[:qty])
          closed_two_weeks_ago = closed_last_week
          closed_last_week = week[:qty]
          week
        end
      end

      private def average(*numbers)
        numbers.reduce(:+) / numbers.length
      end

      private def with_qty(dataset)
        dataset.select { count(:id).as qty }
      end

      private def db
        @db ||= Database.new(options)
      end
    end
  end
end
