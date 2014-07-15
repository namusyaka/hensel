require 'forwardable'
require 'hensel/builder/node'

module Hensel
  class Builder
    class Item < Node
      extend Forwardable

      attr_accessor :text, :url, :options
      attr_accessor :is_first, :is_last, :renderer

      def_delegators :@options, :[], :[]=

      def initialize(text, url, **options)
        @text    = h(text)
        @url     = url
        @options = Hensel.configuration.default_item_options.merge(options)
      end

      def render
        if renderer
          instance_eval(&renderer)
        else
          node(:li, **options) do
            if !Hensel.configuration.last_item_link? && item.last?
              node(:span){ item.text }
            else
              node(:a, href: item.url){ item.text }
            end
          end
        end
      end

      def first?
        !!is_first
      end

      def last?
        !!is_last
      end
    end
  end
end
