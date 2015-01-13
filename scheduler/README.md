# Apify Scheduler
Web admin panel to manage different parser-units and source-servers.
In main app

```ruby
gem 'apify_scheduler'
```

Then mount it in config/routes.rb

mount Apify::Scheduler::Engine => '/admin'

Run migrations in main app

```ruby
bundle exec rake db:migrate
```
