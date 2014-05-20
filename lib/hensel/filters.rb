module Hensel
  module Filters
    extend self

    def register(key, name, block)
      filters[key][name] = block
    end

    def filters
      @filters ||= { filters: {}, richsnippets: {} }
    end

    register :richsnippets, :microdata, ->(this){
      return if this.renderer
      this.renderer = ->(that){
        node(:li, options.merge(itemtype: "http://data-vocabulary.org/Breadcrumb", itemscope: true)) do
          if !Hensel.configuration.last_item_link? && item.last?
            node(:span, itemprop: :title){ item.text }
          else
            node(:a, href: item.url, itemprop: :url) do
              node(:span, itemprop: :title){ item.text }
            end
          end
        end
      }
    }
    
    register :richsnippets, :rdfa, ->(this){
      return if this.renderer
      append_attribute(:"xmlns:v", "http://rdf.data-vocabulary.org/#", this.parent.options)
      this.renderer = ->(that){
        node(:li, options.merge(typeof: "v:Breadcrumb")) do
          if !Hensel.configuration.last_item_link? && item.last?
            node(:span, property: "v:title"){ item.text }
          else
            node(:a, href: item.url, rel: "v:url", property: "v:title"){ item.text }
          end
        end
      }
    }
    
    register :filters, :bootstrap, ->(this){
      append_attribute(:class, "breadcrumb", options)
      append_attribute(:class, "active", items.last.options)
    }
  end
end
