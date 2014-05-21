require 'hensel/builder'

module Hensel
  module Helpers
    def breadcrumbs
      @__breadcrumbs ||= Builder.new
    end
  end
end
