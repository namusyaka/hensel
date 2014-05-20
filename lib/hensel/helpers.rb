require 'hensel/builder'

module Hensel
  module Helpers
    def breadcrumbs
      @breadcrumbs ||= Builder.new
    end
  end
end
