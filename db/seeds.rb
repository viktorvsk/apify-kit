# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
[:second, :minute, :hour, :day, :week, :month].each do |period|
  FrequencyPeriod.create(name: period)
end
User.create( email: 'apify@gmail.com', password: 'password' )
Apify::Scheduler::Server.create( name: 'Local Server', url: 'http://0.0.0.0:5000/apify', api_key: 'secret' )
Apify::Scheduler::Unit.create(
  name: 'Github Blog',
  server: Apify::Scheduler::Server.first,
  destination: 'http://0.0.0.0:5000/test-response',
  frequency_period: FrequencyPeriod.find(2),
  frequency_quantity: 5,
  pattern: %[
    {
      "index": {
        "url": ["https://github.com/blog"],
        "js": false,
        "paginate": [
          "\\/?+$",
          "/?page=<% 1,1,1 %>"
        ]
      },
      "posts": {
        "from": "select('h2.blog-post-title a') from('index')",
        "js": false,
        "host": "http://github.com",
        "pattern": {
          "title": "<% .blog-title %>",
          "meta": {
            "calendar": "<% .blog-post-meta li:first %>",
            "author": "<% .blog-post-meta .vcard %>",
            "category": "<% .blog-post-meta li:last %>"
          },
          "body": "<% .blog-post-body %>"
        }
      }
    }
  ]



 )