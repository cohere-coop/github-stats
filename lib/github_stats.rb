require 'octokit'
require 'sequel'

require_relative 'github_stats/cli'
require_relative 'github_stats/database'
require_relative 'github_stats/reports'
require_relative 'github_stats/created_by_week_report'
require_relative 'github_stats/closed_by_week_report'
require_relative 'github_stats/issue_ingester'

#
module GithubStats
end
