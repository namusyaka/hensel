require 'spec_helper'

describe Hensel::Builder do
  let(:builder){ Hensel::Builder.new }

  describe "#add" do
    context "with basic usage" do
      it "returns an instance of Builder::Item" do
        expect(builder.add("Index", "/")).to be_an_instance_of(Hensel::Builder::Item)
      end

      it "adds an instance of Builder::Item to items" do
        builder.add("Boom", "/boom")
        expect(builder.items.last).to be_an_instance_of(Hensel::Builder::Item)
        expect(builder.items.last.text).to eq("Boom")
      end

      it "allows to set options as the attribute of Builder::Item" do
        builder.add("Foo", "/foo", class: "optional-class", id: "foo-id")
        expect(builder.render).to have_tag(:li, class: "optional-class", id: "foo-id")
      end
    end

    context "with optional usage" do
      it "returns an instance of Builder::Item" do
        expect(builder.add(text: "Index", url: "/")).to be_an_instance_of(Hensel::Builder::Item)
      end

      it "adds an instance of Builder::Item to items" do
        builder.add(text: "Boom", url: "/boom")
        expect(builder.items.last).to be_an_instance_of(Hensel::Builder::Item)
        expect(builder.items.last.text).to eq("Boom")
      end

      it "allows to set options as the attribute of Builder::Item" do
        builder.add(text: "Foo", url: "/foo", class: "optional-class", id: "foo-id")
        expect(builder.render).to have_tag(:li, class: "optional-class", id: "foo-id")
      end
    end
  end

  describe "#remove" do
    context "with text" do
      it "removes the item by text from items" do
        tested = builder.add("Tested", "/tested")
        builder.add("Sample", "/sample")
        builder.remove("Tested")
        expect(builder.items.any?{|x| x.text == tested.text }).to be_false
      end
    end

    context "with block" do
      it "removes the item by result of block from items" do
        tested = builder.add("Tested", "/tested")
        sample = builder.add("Sample", "/sample")
        builder.remove{|x| x.url == "/sample" }
        expect(builder.items.any?{|x| x.text == tested.text }).to be_true
        expect(builder.items.any?{|x| x.text == sample.text }).to be_false
      end
    end
  end

  describe "#render" do
    context "with bootstrap" do
      before { Hensel.configuration.bootstrap = true }
      before(:each) do
        builder.add("Index", "/", class: "dummy-class")
        builder.add("Dummy", "/dummy", class: "dummy-class")
      end
      subject { builder.render }

      it "respects the bootstrap style" do
        expect(subject).to have_tag(:ul, with: { class: "breadcrumb" }) do
          with_tag "li:last-child", class: "active"
        end
      end

      it "respects the microdata rule" do
        expect(subject).to have_tag(:ul, with: { class: "breadcrumb" }) do
          with_tag :li, with: { itemtype: "http://data-vocabulary.org/Breadcrumb", itemscope: "itemscope" }
          with_tag "li > a", with: { href: "/", itemprop: "url" }
          with_tag "li > a > span", with: { itemprop: "title" }
        end
      end

      after { Hensel.configuration.bootstrap = false }
    end

    context "with bootstrap and without richsnippet" do
      before(:all) do
        Hensel.configuration.richsnippet = nil
        Hensel.configuration.bootstrap = true
      end
      before(:each) do
        builder.add("Index", "/", class: "dummy-class")
        builder.add("Dummy", "/dummy", class: "dummy-class")
      end
      subject { builder.render }

      it "respects the bootstrap style" do
        expect(subject).to have_tag(:ul, with: { class: "breadcrumb" }) do
          with_tag "li:last-child", class: "active"
        end
      end

      it "does not respect the microdata rule" do
        expect(subject).not_to have_tag(:li, with: { itemtype: "http://data-vocabulary.org/Breadcrumb", itemscope: "itemscope" })
        expect(subject).not_to have_tag("li > a", text: "Index", with: { href: "/", itemprop: "url" })
        expect(subject).not_to have_tag("li > a", text: "Dummy", with: { href: "/dummy", itemprop: "url" })
      end

      after { Hensel.configuration.bootstrap = false }
    end

    context "without bootstrap" do
      before(:each) do
        builder.add("Index", "/", class: "dummy-class")
        builder.add("Dummy", "/dummy", class: "dummy-class")
      end
      subject { builder.render }
      it "does not respect the bootstrap style" do
        expect(subject).not_to have_tag(:ul, with: { class: "breadcrumb" })
        expect(subject).not_to have_tag("li:last-child", with: { class: "active" })
      end
    end

    context "attr_wrapper" do
      before { Hensel.configuration.attr_wrapper = '"' }
      before(:each){ builder.add("Index", "/", class: "dummy-class") }
      subject { builder.render }
      it { should_not match(/'/) }
      it { should match(/"/) }
      after { Hensel.reset_configuration! }
    end

    context "whitespace" do
      before do
        Hensel.configuration.richsnippet = nil
        Hensel.configuration.whitespace = "  "
      end
      before(:each){ builder.add("Index", "/", class: "dummy-class") }
      let(:fixture){
        <<-FIXTURE.chomp
<ul>
  <li class='dummy-class'>
    <span>
      Index
    </span>
  </li>
</ul>
        FIXTURE
      }
      subject { builder.render }
      it { should eq(fixture) }
    end
  end

  describe "customized breadcrumbs" do
    context "use customizable renderer instead of default renderer" do
      before do
        builder.add("Index", "/")
        builder.add("Dummy", "/dummy")
      end
      subject do
        builder.render do
          node(:custom, href: item.url){ item.text }
        end
      end

      it "can create the html of breadcrumb correctly" do
        builder.add("Index", "/")
        actual_html = builder.render do
          node(:span){ "text: #{item.text}, url: #{item.url}" }
        end
        expect(subject).to have_tag(:ul) do
          with_tag :custom, href: "/"
          with_tag :custom, href: "/dummy"
        end
      end
    end

    context "parent element is not ul but div" do
      before do
        Hensel.configuration.parent_element = :div
        Hensel.configuration.bootstrap = false
        builder.add("Index", "/")
      end
      subject { builder.render }

      it "can set parent element for customizable breadcrumb" do
        expect(subject).to have_tag(:div, { class: "breadcrumb" }) do
          with_tag "li", class: "active"
        end
      end

      after do
        Hensel.configuration.parent_element = :ul
        Hensel.configuration.bootstrap = false
      end
    end
  end
end
