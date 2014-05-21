require 'spec_helper'
require File.expand_path("../../lib/hensel/sinatra", __FILE__)

describe Hensel::Helpers::SinatraHelpers do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def mock_app(&block)
    @app = Sinatra::Application
    block_given? ? @app.instance_eval(&block) : @app
  end

  describe "basic usage" do
    before do
      mock_app do
        helpers Hensel::Helpers::SinatraHelpers
        set :hensel, builder_options: { class: 'custom-breadcrumbs' },
                     renderer: proc { node(:custom){ item.text }}

        configure do
          Hensel.configure do |config|
            config.before_load = proc { add "Home", "/" }
            config.indentation = false
          end
        end

        get '/hey' do
          breadcrumbs.add("Hey", "/hey")
          breadcrumbs.render
        end

        get '/ho' do
          breadcrumbs.add("Ho", "/ho")
          breadcrumbs.render do
            node(:awesome){ item.text }
          end
        end
      end
    end

    it "can change the settings of hensel using `set` method" do
      get '/hey'
      expect(last_response.body).to have_tag(:ul, class: "custom-breadcrumb") do
        with_tag(:custom, text: "Home")
        with_tag(:custom, text: "Hey")
      end
    end

    it "should respect it when render is passed block as an argument" do
      get '/ho'
      expect(last_response.body).to have_tag(:ul, class: "custom-breadcrumb") do
        with_tag(:awesome, text: "Home")
        with_tag(:awesome, text: "Ho")
      end
    end
  end
end
