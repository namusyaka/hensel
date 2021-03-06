require 'spec_helper'

describe Hensel::Helpers::TagHelpers do
  let(:helpers){ Object.new }
  before { helpers.extend Hensel::Helpers::TagHelpers }

  describe "#contegt_tag" do
    context "with block" do
      subject { helpers.content_tag(:div, class: "dummy-class"){ "hello" }}
      it { is_expected.to have_tag(:div, content: "hello", class: "dummy-class") }
    end

    context "without block" do
      subject { helpers.content_tag(:div, "hello", class: "dummy-class")}
      it { is_expected.to have_tag(:div, content: "hello", class: "dummy-class") }
    end

    context "with indentation" do
      before { Hensel.configuration.indentation = true }
      subject { helpers.content_tag(:div, "hello", indent: 2, class: "dummy-class")}
      it { expect(subject.start_with?("    ")).to be_truthy }
    end

    context "without indentation" do
      before { Hensel.configuration.indentation = false }
      subject { helpers.content_tag(:div, "hello", indent: 2, class: "dummy-class")}
      it { expect(subject.start_with?("<div")).to be_truthy }
    end
  end

  describe "#tag" do
    subject { helpers.tag(:img, class: "sample-image", src: "sample.jpg", alt: "sample image") }
    it { is_expected.to have_tag(:img, class: "sample-image", src: "sample.jpg", alt: "sample image") }
  end

  describe "#append_attribute" do
    subject { Hash.new }
    before { helpers.append_attribute(:key, :value, subject) }
    it { expect(subject[:key]).to eq(:value) }
  end
end
