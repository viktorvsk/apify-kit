module Apify
  module Core
    class Parser

      def initialize(html="", pattern={})
        @html, @pattern, @doc, @result = html, pattern, ::Nokogiri::HTML(html), {}
      end

      def perform
        @pattern.each do |key,value|
          next if key == '__iterator__'
          @result[key] = process(value, @doc)
        end
        @result
      end

      def self.fetch(expression, docs)
        res = []
        docs.each do |html|
          r = (::Nokogiri::HTML(html).search(expression).to_s rescue nil)
          res << r
        end
        a = res.compact.map{ |node| ::Nokogiri::HTML(node).at_css('body').children rescue nil }.flatten.compact
        a        
      end

      private
      def process(value, context)
        case value
        when Hash
          if value.keys.include?('__iterator__')
            new_hash = []
            context = context.search(value['__iterator__'].strip)
            context.each_with_index do |node, index|
              new_hash[index] = {}
              value.each do |k,v|
                next if k == '__iterator__'
                new_hash[index][k] = process(v, node)
              end
            end

            new_hash
          else
            new_hash = {}
            value.each do |k,v|
              new_hash[k] = process(v, context)
            end
            new_hash
          end
        when Array
          value.map{ |v| process(v, context) }
        when String
          matcher = value.scan(/<%\s?+(.*?)\s?+%>/)
          # <% single selector %>
          if matcher and matcher.size == 1
            expression_and_filters = value[2...-2].split('|').map(&:strip)
            expression = expression_and_filters[0].strip
            filters = expression_and_filters[1..-1]
            filters = ['first', 'text', 'strip'] unless filters.present?

            result = context.search(expression)
            result ? Filter.apply(result, filters) : nil
          # <% selector %> --- <% another selector %>
          elsif matcher and matcher.size > 1
            value.gsub(/<%\s?+(.*?)\s?+%>/) { process("<% #{$1.strip} %>", context) }
          else
            value
          end
        end
      end

    end
  end
end
