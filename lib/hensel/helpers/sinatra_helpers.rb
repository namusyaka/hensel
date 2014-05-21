module Hensel
  module Helpers
    module SinatraHelpers
      def __hensel
        @__hensel ||= settings.respond_to?(:hensel) ? settings.hensel : {}
      end

      def breadcrumbs
        @__breadcrumbs ||=
          begin
            builder = Hensel::Builder.new(__hensel[:builder_options] || {})
            renderer = __hensel[:renderer]
            if renderer && renderer.instance_of?(Proc)
              builder.singleton_class.send(:define_method, :render) do |&block|
                if block.instance_of?(Proc)
                  super(&block)
                else
                  concatenated_items =
                    map_items do |item|
                      renderer.arity.zero? ? item.instance_eval(&renderer) : renderer.call(item)
                    end.join(Hensel.configuration.indentation? ? "\n" : "")
                  content_tag(Hensel.configuration.parent_element, concatenated_items, options)
                end
              end
            end
            builder
          end
      end
    end
  end
end
