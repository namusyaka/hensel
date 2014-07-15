require 'spec_helper'

describe Hensel::Builder::Node do
  let(:item) { Hensel::Builder::Item.new("index", "/") }
  before { Hensel.configuration.indentation = false }

  describe "#render" do
  end

  describe "#node" do
    context "with block" do
      subject { item.render }
      it "can build html correctly" do
        item.renderer = ->(this){ node(:div, class: "hey"){ "sample text" }}
        is_expected.to have_tag(:div, text: "sample text", class: "hey")
      end

      it "can build html correctly even when node is nested" do
        item.renderer = ->(this){ node(:div, class: "hey"){ node(:span){ "nested text" } }}
        is_expected.to have_tag(:div, class: "hey") do
          with_tag(:span, text: "nested text")
        end
      end

      it "should support same hierarchy elements" do
        item.renderer = ->(this){
          node(:div) do
            node(:span){ "one1" }
            node(:span){ "one2" }
          end
        }
        is_expected.to have_tag(:div) do
          with_tag(:span, text: "one1")
          with_tag(:span, text: "one2")
        end
      end
    end

    context "without block" do
      subject { item.render }
      it "can build html correctly" do
        item.renderer = ->(this){ node(:div, "sample text", class: "hey") }
        is_expected.to have_tag(:div, content: "sample text", class: "hey")
      end

      it "can build html correctly even when node is nested" do
        item.renderer = ->(this){ node(:div, class: "hey"){ node(:span, "nested text") }}
        is_expected.to have_tag(:div, class: "hey") do
          with_tag(:span, content: "nested text")
        end
      end

      it "should support same hierarchy elements" do
        item.renderer = ->(this){
          node(:div) do
            node(:span, "one1")
            node(:span, "one2")
          end
        }
        is_expected.to have_tag(:div) do
          with_tag(:span, text: "one1")
          with_tag(:span, text: "one2")
        end
      end
    end
  end

  describe "#item" do
    subject { item.render }
    it "can be referred from block" do
      item.renderer = ->(this){ node(:div, item.text) }
      is_expected.to have_tag(:div, text: "index")
    end
  end
end
