$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "apify_scheduler/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "apify_scheduler"
  s.version     = Apify::Scheduler::VERSION
  s.authors     = ["victorvsk"]
  s.email       = ["victor@vyskrebentsev.ru"]
  s.homepage    = ""
  s.summary     = "Apify Scheduler is an easy interface to manage your parser instances."
  s.description = "Create instance (i.e. JSON representation of site crawling rules), set Server Nodes addresses with callback urls and choose schedule time."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.8"
  s.add_dependency "rest-client"
  s.add_dependency "resque", "1.25.2"

end
