require_relative 'database'
require_relative 'report'
module GithubStats
  module Reports
    # Provides week-by-week breakdown of issues closed, grouped by week
    # with a 3 week moving average.
    class ClosedByWeekReport
      attr_accessor :search_string, :options
      include Report

      def results
        results = with_moving_average(:velocity,
                                      by_week_closed(with_qty(issues)))
        Reports::Results.new(results, keys: [:week_closed, :qty, :velocity])
      end

      private def by_week_closed(dataset)
        dataset.select_append { strftime('%Y-%W', closed_at).as(week_closed) }
          .group_by(:week_closed)
      end

      private def issues
        db.issues.where(search_string: search_string).where { closed_at !~ nil }
      end
    end
  end
end
