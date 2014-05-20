module Hensel
  module Helpers
    module TagHelpers
      ESCAPE_VALUES = {
        "'" => "&#39;",
        "&" => "&amp;",
        "<" => "&lt;",
        ">" => "&gt;",
        '"' => "&quot;"
      }
      ESCAPE_REGEXP = Regexp.union(*ESCAPE_VALUES.keys)
      BOOLEAN_ATTRIBUTES = [
        :autoplay,
        :autofocus,
        :formnovalidate,
        :checked,
        :disabled,
        :hidden,
        :loop,
        :multiple,
        :muted,
        :readonly,
        :required,
        :selected,
        :declare,
        :defer,
        :ismap,
        :itemscope,
        :noresize,
        :novalidate
      ]
  
      def content_tag(name, content = nil, **options, &block)
        base = tag(name, options)
        content = instance_eval(&block) if !content && block_given?
        if indentation?
          indent = options.fetch(:indent, 0)
          base << "\n"
          base << (content.strip.start_with?("<") ? content : (whitespace(indent + 1)) + content)
          base << "\n"
          base << "#{whitespace(indent)}</#{name}>"
        else
          "#{base}#{content}</#{name}>"
        end
      end
  
      def tag(name, indent: 0, **options)
        "#{indentation? ? whitespace(indent) : ""}<#{name}#{tag_attributes(options)}>"
      end
  
      def append_attribute(attribute, value, hash)
        if hash[attribute]
          unless hash[attribute].to_s.split(" ").include?(value)
            hash[attribute] = (Array(hash[attribute]) << value) * " " 
          end
        else
          hash.merge!(attribute => value)
        end
      end
  
      private
  
      def tag_attributes(options)
        return '' if options.nil?
        attributes = options.map do |k, v|
          next if v.nil? || v == false
          if v.is_a?(Hash)
            nested_values(k, v)
          elsif BOOLEAN_ATTRIBUTES.include?(k)
            %(#{k}=#{attr_wrapper}#{k}#{attr_wrapper})
          else
            %(#{k}=#{attr_wrapper}#{h(v)}#{attr_wrapper})
          end
        end.compact
        attributes.empty? ? '' : " #{attributes * ' '}"
      end
  
      def nested_values(attribute, hash)
        hash.map do |k, v|
          if v.is_a?(Hash)
            nested_values("#{attribute}-#{k.to_s}", v)
          else
            %(#{attribute}-#{k.to_s}=#{attr_wrapper}#{h(v)}#{attr_wrapper}")
          end
        end * ' '
      end

      def h(string)
        Hensel.configuration.escape_html? ? escape_html(string) : string
      end
  
      def escape_html(string)
        string.to_s.gsub(ESCAPE_REGEXP) { |c| ESCAPE_VALUES[c] }
      end
  
      def attr_wrapper
        @attr_wrapper ||= Hensel.configuration.attr_wrapper
      end
  
      def whitespace(indent = nil)
        if indent.nil?
          @whitespace ||= Hensel.configuration.whitespace
        else
          whitespace * indent
        end
      end
  
      def indentation?
        @indentation ||= Hensel.configuration.indentation?
      end
    end
  end
end
