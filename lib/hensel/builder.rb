require 'hensel/builder/item'
require 'hensel/helpers/tag_helpers'
require 'hensel/filters'

module Hensel
  class Builder
    include Helpers::TagHelpers

    attr_reader :items, :options

    def initialize(**options)
      @items   = []
      @options = options
      instance_eval(&Hensel.configuration.before_load) if Hensel.configuration.before_load
    end

    # Adds an item to items
    def add(*arguments)
      items << (item = Item.new(*parse_arguments(arguments)))
      item.parent = self
      item
    end

    # Removes the item from items
    # @example without block
    #   builder = Hensel::Builder.new
    #   builder.add("Index", "/")
    #   builder.remove("Index")
    #
    # @example with block
    #   builder = Hensel::Builder.new
    #   builder.add("Index", "/")
    #   builder.remove{|item| item.text == "Index" }
    def remove(text = nil, &block)
      block_given? ? items.delete_if(&block) : items.delete_if{|item| text == item.text }
    end

    # Renders the breadcrumb html
    def render(&block)
      process! unless processed?

      concatenated_items = map_items do |item|
        if block_given?
          block.arity.zero? ? item.instance_eval(&block) : block.call(item)
        else
          item.render
        end
      end.join(Hensel.configuration.indentation? ? "\n" : "")

      content_tag(Hensel.configuration.parent_element, concatenated_items, options)
    end

    def processed?
      !!@processed
    end

    private

    def map_items
      items_length = items.length.pred
      items.map.with_index do |item, index|
        if index == items_length
          item._last = true
        elsif index.zero?
          item._first = true
        else
          item._first = item._last = false
        end
        item_filters.each{|filter| item.instance_eval(&filter) } unless item_filters.empty?
        yield item
      end
    end

    def item_filters
      @item_filters ||= []
    end

    # @!visibility private
    def process!
      configuration = Hensel.configuration

      Hensel::Filters.filters[:filters].each_pair do |name, block|
        instance_eval(&block) if configuration.send(:"#{name}?")
      end
      richsnippet_filter = Hensel::Filters.filters[:richsnippets][configuration.richsnippet]
      item_filters << richsnippet_filter if richsnippet_filter
      @processed = true
    end

    # @!visibility private
    def parse_arguments(arguments)
      case arguments.length
      when 3
        arguments
      when 2
        arguments << {}
      when 1
        if (options = arguments.first) && options.instance_of?(Hash)
          [ options.delete(:text) || options.delete(:content), options.delete(:path) || options.delete(:url), options ]
        else
          raise ArgumentError
        end
      end
    end
  end
end
