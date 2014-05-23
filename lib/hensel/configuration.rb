module Hensel
  class Configuration
    # Define the accessor as boolean method
    def self.attr_boolean_accessor(*keys)
      keys.each do |key|
        attr_accessor key
        define_method("#{key}?"){ !!__send__(key) }
      end
    end

    attr_boolean_accessor :bootstrap
    attr_boolean_accessor :escape_html
    attr_boolean_accessor :indentation
    attr_boolean_accessor :last_item_link

    attr_accessor :attr_wrapper, :whitespace, :parent_element, :richsnippet, :before_load,
                  :default_item_options

    def initialize
      @bootstrap            = false
      @escape_html          = true
      @indentation          = true
      @last_item_link       = false
      @richsnippet          = :microdata # [:microdata, :rdfa, :nil]
      @attr_wrapper         = "'"
      @whitespace           = "  "
      @parent_element       = :ul 
      @before_load          = nil
      @default_item_options = {}
    end

    def [](key)
      instance_variable_get(:"@#{key}")
    end

    def []=(key, value)
      instance_variable_set(:"@#{key}", value)
    end
  end
end
