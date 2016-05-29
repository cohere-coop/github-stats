Gem::Specification.new do |s|
  s.name                  = 'github-stats'
  s.version               = '0.1.0'
  s.licenses              = ['MIT']
  s.summary               = 'Project-management oriented stats for github'
  s.description           = 'Throughput, cycle time, velocity, etc'
  s.homepage              = 'https://github.com/zincmade/github-stats'
  s.authors               = ['Zee@Zinc']
  s.email                 = 'zee+github-stats@zincma.de'
  s.files                += Dir['lib/**/*.rb'] + Dir['bin/*']
  s.extra_rdoc_files      = ['README.md', 'CODE_OF_CONDUCT.md', 'LICENSE']
  s.required_ruby_version = '~> 2.0'
  s.bindir                = 'bin'
  s.executables          += ['github-stats']
  s.add_runtime_dependency 'octokit', '~> 4.3'
  s.add_runtime_dependency 'sqlite3', '~> 1.3'
  s.add_runtime_dependency 'sequel', '~> 4.34'
end
