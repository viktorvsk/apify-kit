# Welcome to Apify Kit

Apify Kit is a tool for centralized html parser (scraping/crawling).

# Features

- Hash-based syntax to parse HTML DOM elements.
- Scraping web-sites with or without javascript enabled.
- Configure number of processes of scraping.
- Configure delay between requests.
- Handfull filters to further processing of HTML nodes.
- Web-server to crawl web-sites from separate nodes.
- Built-in local web-server.
- Handful web-admin interface with queues, scheduling and histories.

# Requirements

- Redis
- Foreman

# Usage
1. Clone this repo
    $ git clone git@github.com:victorvsk/apify-kit.git
2. Bundle gems
    $ cd  apify-kit
    $ bundle install
3. Run Foreman
    $ gem install foreman
    $ foreman start
4. Open http://localhost:5000 and use demo credentials:
login: apify@gmail.com
password: password
apify_secret: secret

# Apify Secret Key

While web admin is protected with devise, embedded web-server, which is mounted to /apify in config/routes.rb,
has to be public accessible. That is why it is protected with apify_secret environment variable.
It can be configured, for example, on the top of config/application.rb:

```ruby
ENV["APIFY_SECRET"] ||= 'secret'
```

Note, it should be set before entire rails app is loaded, due to server in fact is a Sinatra Application which is loaded once on startup.

# Road map

- Deployment recipies.
- Cover Core part with rspec.
- More configurable server node.
- Distribute every part as a gem for easier scaling.
- Cover Server part with rspec.
- Cover scheduler part with rspec.