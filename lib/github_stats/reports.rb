require_relative 'closed_by_week_report'
require_relative 'cycle_time_report'
require_relative 'created_by_week_report'

module GithubStats
  module Reports
    def self.for(report_type)
      { 'closed_by_week' => ClosedByWeekReport,
        'created_by_week' => CreatedByWeekReport,
        'cycle_time' => CycleTimeReport }.fetch(report_type)
    end

    # Provides enumerable access to the results
    class Results
      attr_accessor :data, :keys
      extend Forwardable
      def_delegators :data, :each, :map

      def initialize(data, keys: [])
        self.data = data
        self.keys = keys
      end
    end
  end
end
