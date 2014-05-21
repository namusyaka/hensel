require 'spec_helper'

describe Hensel::Configuration do
  let(:configuration){ Hensel::Configuration.new }
  let(:variables){ configuration.instance_variables.map{|v| v[1..-1] } }
  describe ".attr_boolean_accessor" do
    it "can define an accessor and boolean methods" do
      expect(configuration.respond_to?(:sample)).to be_false
      Hensel::Configuration.attr_boolean_accessor :sample
      expect(configuration.respond_to?(:sample)).to be_true
    end
  end

  describe "#[]" do
    it "can get value of instance variables" do
      variables.each.with_index do |variable, index|
        configuration.send("#{variable}=", index)
        expect(configuration[variable]).to eq(index)
      end
    end
  end

  describe "#[]=" do
    it "can set value to instance variables" do
      variables.each.with_index do |variable, index|
        configuration.send(:[]=, variable, index)
        expect(configuration[variable]).to eq(index)
      end
    end
  end
end
