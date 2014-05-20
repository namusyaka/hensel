require 'spec_helper'

describe Hensel::Helpers::TagHelpers do
  let(:helpers){ Object.new }
  before { helpers.extend Hensel::Helpers::TagHelpers }

  describe "#contegt_tag" do
    context "with block" do
      subject { helpers.content_tag(:div, class: "dummy-class"){ "hello" }}
      it { should have_tag(:div, content: "hello", class: "dummy-class") }
    end

    context "without block" do
      subject { helpers.content_tag(:div, "hello", class: "dummy-class")}
      it { should have_tag(:div, content: "hello", class: "dummy-class") }
    end

    context "with indentation" do
      before { Hensel.configuration.indentation = true }
      subject { helpers.content_tag(:div, "hello", indent: 2, class: "dummy-class")}
      it { expect(subject.start_with?("    ")).to be_true }
    end

    context "without indentation" do
      before { Hensel.configuration.indentation = false }
      subject { helpers.content_tag(:div, "hello", indent: 2, class: "dummy-class")}
      it { expect(subject.start_with?("<div")).to be_true }
    end
  end

  describe "#tag" do
    subject { helpers.tag(:img, class: "sample-image", src: "sample.jpg", alt: "sample image") }
    it { should have_tag(:img, class: "sample-image", src: "sample.jpg", alt: "sample image") }
  end

  describe "#append_attribute" do
    subject { Hash.new }
    before { helpers.append_attribute(:key, :value, subject) }
    it { subject[:key].should eq(:value) }
  end
end
