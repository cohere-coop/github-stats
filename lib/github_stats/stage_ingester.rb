require_relative 'github_client'
module GithubStats
  # Retrieves events from Github and upserts stages into the database
  class StageIngester
    def initialize(issues, database, github)
      self.database = database
      self.github = github
      self.issues = issues
    end

    def ingest
      issues.each(&:ingest_stages)
    end

    def ingest_stages(issue)
      github.issue_events(issue.repo, issue.number).each do |event|
        puts event
      end
    end
  end
end
