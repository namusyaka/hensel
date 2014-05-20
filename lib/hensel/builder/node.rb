require 'hensel/helpers/tag_helpers'

module Hensel
  class Builder
    class Node < Struct.new(:name, :attributes, :content, :parent, :indent)
      include Hensel::Helpers::TagHelpers

      def node(name, content = nil, **attributes, &block)
        element = Node.new(name, attributes, content, self, child_indent)
        content =
          if block_given?
            result = element.instance_eval(&block)
            element.children.length.zero? ? result : element.render
          else
            content
          end
        children << (child = content_tag(name, content, attributes.merge!(indent: child_indent), &block))
        child
      end

      def render
        children.join(Hensel.configuration.indentation? ? "\n" : "")
      end

      def children
        @children ||= []
      end

      def item
        @item ||=
          begin
            return self if self.instance_of?(Hensel::Builder::Item)
            ancestor = parent
            while ancestor.instance_of?(Hensel::Builder::Node)
              ancestor = ancestor.parent
            end
            ancestor
          end
      end

      private

      def child_indent
        @child_indent ||= 
          if Hensel.configuration.indentation?
            indent ? indent + 1 : 1
          else
            0
          end
      end
    end
  end
end
