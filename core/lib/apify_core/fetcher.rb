module Apify
  module Core
    class Fetcher
      attr_accessor :sources
      attr_accessor :result

      def initialize( pages, processes=2, delay=0 )
        @pages = pages
        @processes = processes
        @delay = delay
      end

      def prepare
        @pages.each do |key, value|
          value[:url] = Filter.apply(value[:url], ['map_urlencode'])
          self.class.send(:attr_reader, key.to_sym)
          js  = value[:js] || false
          pattern = value[:pattern]
          host = value[:host]
          if value[:from]
            v =  value
            instance_variable_set("@#{key}".to_sym, v)
            next
          end
          url = self.class.base_url_for(value[:url], value[:host])

          if value[:paginate]
            pages = self.class.paginate(url: url, to_replace: value[:paginate][0], pagination: value[:paginate][1])
            result = { pages: pages }
          else
            url = (url.respond_to?(:each) ? url : url.to_s)
            result = { pages: [url] }
          end
          result[:js] = js
          result[:pattern] = pattern
          result[:host] = host
          instance_variable_set("@#{key}".to_sym, result)

        end
        self.sources = @pages.keys
      end

      def perform
        parenthesis_args = /\([\"\'](.*?)[\"\']\)/
        self.sources.each do |source|

          if @pages[source].key?(:from)
            expression = @pages[source][:from]
            statement = {
              select:   expression.match(/select#{parenthesis_args}/)[1],
              from:     expression.match(/from#{parenthesis_args}/)[1],
              filters:  (expression.match(/filter#{parenthesis_args}/)[1].split('|').map(&:strip) rescue nil),
            }
            statement[:filters] = ['mapattr_href', 'map_urlencode'] unless statement[:filters].present?
            urls = Filter.apply(Parser.fetch(statement[:select], self.send(statement[:from])[:pages]), statement[:filters])
            @pages[source][:pages] = self.class.base_url_for(urls, @pages[source][:host])
          end
          src = self.send(source)
          method = src[:js] ? :js : :normal
          processes_number = (method == :js ? 1 : @processes )
          src[:pages] = ::Parallel.map(src[:pages], in_processes: processes_number) do |url_or_array|
            if url_or_array.respond_to?(:each)
              res = []
              url_or_array.each do |url|

                res << self.class.download( url, method )
              end
              res
            else
              self.class.download( url_or_array, method )
            end
          end.flatten
        end

        result = {}
        self.sources.each do |source|
          src = self.send(source)
          pattern = src[:pattern] ? src[:pattern].dup : false
          elem = if src[:pattern]
            src[:pages].map{ |html| Parser.new(html, src[:pattern]).perform }
          else

            src[:pages]
          end

          result[source] = elem if pattern
          instance_variable_set("@#{source}".to_sym, elem )
        end

        @result = result
        @json = result
      end

      def to_json
        (@json || perform).to_json
      end

      class << self

        # Fetcher::Fetcher.paginate(url: 'http://site.com', to_replace: '(\/?)$', pagination: '?page=<% 1,5,1 %>')

        def paginate( opts={} )
          pagination = opts[:pagination] || '?page=<% 1,5,1 %>'
          to_replace = opts[:to_replace] || '(\/?)\Z'
          url_or_array_of_urls = opts[:url]
          raise ArgumentError, "URL parameter missing" if url_or_array_of_urls.nil?
          regexp = /<%\s?+(\d+,\d+,\d+)\s?+%>/
          pattern = pagination.scan(regexp)
          return [opts[:url]] if pattern.count == 0
          raise ArgumentError, "Only one pagination pattern allowed." if pattern.count > 1
          result = []
          pager_args = pattern.first.first.split(',').map(&:strip).map(&:to_i)
          range = (pager_args[0]..pager_args[1])
          range.step(pager_args[2]).each do |page|

            to_append = pagination.gsub(regexp, page.to_s)
            if url_or_array_of_urls.respond_to?(:each)
              url_or_array_of_urls.each do |url|
                result << url.to_s.chomp('/').gsub(Regexp.new(to_replace), to_append)
              end
            else
              result << url_or_array_of_urls.to_s.chomp('/').gsub(Regexp.new(to_replace), to_append)
            end

          end

          result
        end

        def download( url, method=:normal )
          sleep @delay if @delay.to_i > 0
          result = case method
          when :js
            headless = Headless.new
            headless.start
            browser = Watir::Browser.new
            browser.goto url
            html = browser.html
            headless.destroy
            print "+"
            html
          when :normal
            begin
              html = RestClient.get(url,
                      'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                      'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4',
                      'Connection'      => 'keep-alive',
                      'User-Agent'      => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/39.0.2171.65 Chrome/39.0.2171.65 Safari/537.36')
              d = Nokogiri::HTML(html)
              charset = d.search('//meta[contains(translate(@http-equiv,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz"),"content-type")]').last['content'].match(/charset=(.+)/)[1].downcase rescue nil
              if charset.present? and charset != 'utf-8'
                html = html.force_encoding(charset).encode("utf-8", undef: :replace)
              end
              print "+"
              html
            rescue RestClient::RequestTimeout, RestClient::ResourceNotFound, RestClient::InternalServerError, URI::InvalidURIError, RestClient::Forbidden,RestClient::BadGateway, RestClient
              print "-"
              return
            end
          end

          result
        end

        def base_url_for(url_or_array, base_url)

          if url_or_array.respond_to?(:each)
            result = []
            url_or_array.each do |url|
              #url = URI(URI.encode(url))
              url = URI(url)
              raise ArgumentError, "No host provided." if url.host.nil? and base_url.nil?
              result << (url.host ? url.to_s : "#{base_url}#{url}")
            end
            result
          else
            #url = URI(URI.encode(url_or_array))
            url = URI(url_or_array)
            raise ArgumentError, "No host provided." if url.host.nil? and base_url.nil?
            (url.host ? url : "#{base_url}#{url}")
          end

        end

      end


    end
  end
end