# Apify Server

## Installation

Install gem:

    $ gem install apify_server

## Prepare

    $ APIFY_SECRET=secret apify-server

## Use

    $ curl -X POST \
    > -H "Content-type: application/json" \
    > -d '{ "html": "<div id='title'>text</div>", "pattern": { "title": "<% #title | first | html %>" }}' \
    > http://0.0.0.0:4567/parser?apify_secret=secret

## Contributing

1. Fork it ( https://github.com/victorvsk/apify-kit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
