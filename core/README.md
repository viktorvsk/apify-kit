# Apify Core

Apify Core is a part of Apify Project. Parse HTML\XML to JSON with easy API and useful filters.
Apify Project allows even more - parsing entire website with east.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apify_core'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apify_core

## Usage

```
html = RestClient.get('http://github.com')
pattern = { title: '<% title %>' }
title = Apify::Core.new(html, pattern).perform # GitHub · Build software better, together.
```

```
request = { github: { url: ['http://github.com'], js: false, host: 'http://github.com', pattern: { title: '<% title %>' } } }
response = Apify.crawl!(request) # { "github": { "title": "GitHub · Build software better, together." } }
```

See more in documentation (TODO). Also some syntax examples can be found in spec/examples.

## Contributing

1. Fork it ( https://github.com/victorvsk/apify-kit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
