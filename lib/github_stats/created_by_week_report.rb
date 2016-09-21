require_relative 'database'
require_relative 'report'
module GithubStats
  module Reports
    # Provides week-by-week breakdown of issues created, grouped by week
    # with a 3 week moving average.
    class CreatedByWeekReport
      attr_accessor :search_string, :options

      include Report

      def results
        results = with_moving_average(:add_rate,
                                      by_week_created(with_qty(issues)))
        Reports::Results.new(results, keys: [:week_created, :qty, :add_rate])
      end

      private def by_week_created(dataset)
        dataset.select_append { strftime('%Y-%W', created_at).as(week_created) }
          .group_by(:week_created)
      end

      private def issues
        db.issues.where(search_string: search_string)
          .where { created_at !~ nil }
      end
    end
  end
end
