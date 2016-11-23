require_relative 'database'
require_relative 'report'
module GithubStats
  module Reports
    # Provides issue cycle time from started at to done
    class CycleTimeReport
      attr_accessor :search_string, :options
      include Report

      def results
        Results.new(with_cycle_time(issues), keys: [:week_closed, :created_at, :started_at, :closed_at, :cycle_time, :url])
      end

      private def with_cycle_time(dataset)
        dataset.all.map do |item|
          item[:week_closed] = (item[:closed_at].strftime("%Y-%W"))
          item[:cycle_time] = work_days_between(item[:closed_at], item[:started_at])
          item
        end
      end

      private def work_days_between(end_time, start_time)
        hours_between = (end_time - start_time) / 60 / 60
        return hours_between.to_f / 24.to_f if hours_between < 12
        days_between = (end_time.strftime('%j').to_i - start_time.strftime('%j').to_i)
        weeks_between = (end_time.strftime('%W').to_i - start_time.strftime('%W').to_i)
        return (hours_between - (days_between * 10 + weeks_between * 28)).to_f / 24.to_f
      end

      private def issues
        db.issues.where(search_string: search_string).where { closed_at !~ nil }
                                                     .where { started_at !~ nil }
      end
    end
  end
end
