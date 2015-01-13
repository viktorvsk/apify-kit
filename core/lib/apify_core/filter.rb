module Apify
  module Core
    module Filter
      class << self

        def apply(node_or_str, filters=[])
          return node_or_str if filters.empty? or node_or_str.nil?
          method = filters.shift
          filtered_value = send(method, node_or_str)
          apply(filtered_value, filters)
        end

        private

        def first(node)
          node.first
        end

        def text(node)
          node.text
        end

        def strip(str)
          str.strip if str
        end

        def list(node)
          node
        end

        def html(node)
          node.to_s
        end

        def inner_html(node)
          node.inner_html.to_s
        end

        def map_text(node)
          node.map(&:text).map(&:strip)
        end

        def map_html(node)
          node.map(&:to_s)
        end

        def map_inner_html(node)
          node.map(&:inner_html).map(&:to_s)
        end


        def map_urlencode(node)
          node.map do |url|
            urlencode(url)
          end
        end

        def urlencode(url)
          url = begin
            url = URI(url)
            url
          rescue URI::InvalidURIError
            URI.encode(url)
          end
        end

        def method_missing(method_sym, *arguments, &block)
          if method_sym =~ /\Amapattr_/
            attribute = method_sym.to_s.gsub('mapattr_', '')
            arguments.first.map{ |n| n[attribute] }
          elsif method_sym =~ /\Aattr_/
            attribute = method_sym.to_s.gsub('attr_', '')
            arguments.first[attribute]
          else
            super
          end
        end


      end
    end
  end
end