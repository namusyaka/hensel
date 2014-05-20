require 'spec_helper'

describe Hensel::Configuration do
  describe ".attr_boolean_accessor" do
    let(:configuration){ Hensel::Configuration.new }
    it "can define an accessor and boolean methods" do
      expect(configuration.respond_to?(:sample)).to be_false
      Hensel::Configuration.attr_boolean_accessor :sample
      expect(configuration.respond_to?(:sample)).to be_true
    end
  end

  describe "#[]" do
  end

  describe "#[]=" do
  end
end
