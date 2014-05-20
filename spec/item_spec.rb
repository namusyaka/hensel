require 'spec_helper'

describe Hensel::Builder::Item do
  let(:builder){ Hensel::Builder.new }

  context "with escape_html" do
    before(:all) do
      Hensel.configuration.escape_html = true
      Hensel.configuration.indentation = false
    end
    before(:each){ builder.add('\'&"<>', '/') }
    subject { builder.items.last.text }
    it { should eq('&#39;&amp;&quot;&lt;&gt;') }
  end

  context "without escape_html" do
    before(:all) do 
      Hensel.configuration.escape_html = false
      Hensel.configuration.indentation = false
    end
    before(:each){ builder.add('\'&"<>', '/') }
    subject { builder.items.last.text }
    it { should eq('\'&"<>') }
  end

  describe "#render" do
    let(:item) { Hensel::Builder::Item.new("index", "/") }
    subject { item.render }
    context "basic usage" do
      it { should have_tag(:li){ with_tag(:a, href: "/") } }
    end

    context "with customized renderer" do
      it "can be set to renderer" do
        item.renderer = ->(this){ node(:custom, data: "sample"){ item.text } } 
        should have_tag(:custom, text: "index", data: "sample")
      end
    end
  end
end
