require "hensel/version"
require "hensel/configuration"
require "hensel/builder"
require "hensel/helpers"

module Hensel
  extend self

  # Yields Hensel configuration block
  # @example
  #   Hensel.configure do |config|
  #     config.attr_wrapper = '"'
  #   end
  # @see Hensel::Configuration
  def configure
    yield configuration
    configuration
  end

  # Returns Hensel configuration
  def configuration
    @configuration ||= Configuration.new
  end

  # Resets Hensel configuration
  def reset_configuration!
    @configuration = nil
  end
end
