# Github Issue Stats [![Gem Version](https://badge.fury.io/rb/github-stats.svg)](https://badge.fury.io/rb/github-stats)


Github issues are a decent way to track work on a small project; and with the rise of tools such as Waffle.io and ZenHub, it appears that they will slowly but surely become better and better for managing long term projects.

However statistical analysis of github issues is still very much lacking. `github-stats` is a command line tool / gem that takes github searches and converts them into useful project reports.

## Installation & Usage
Assuming you are using Ruby 1.9.3 or above: `gem install github-stats` will install the tool. Running `github-stats "whatever github search string you want"` will run the search, outputting a closed by week report.

For a detailed list of options and command line flags, please refer to `github-stats --help`.

**Please Note!** Github's Search API restricts searches to [the first 1,000 results](https://developer.github.com/v3/search/#about-the-search-api) and limits [unauthenticated requests to 10 per minute](https://developer.github.com/v3/search/#rate-limit). This means you can run 1 report per-minute that would return a full 1,000 issues.

I recommend using filters such as [`state:closed`](https://help.github.com/articles/searching-issues/#search-based-on-whether-anor-pull-request-is-open) and/or [`updated:>=2016-01-01`](https://help.github.com/articles/searching-issues/#search-based-on-when-anor-pull-request-was-created-or-last-updated) to scope your requests down, based upon the report type.

### Example
The following example shows how to get a closed by week report for Rails for the first 4 weeks of May 2016
```
$ github-stats "repo:rails/rails type:issue is:closed closed:2016-05-01..2016-05-28"
2016-17 3 1
2016-18 27 10
2016-19 30 20
2016-20 20 25
2016-21 20 23
```
