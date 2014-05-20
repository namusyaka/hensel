require 'spec_helper'

describe Hensel::Helpers do
  let(:object){ Object.new }
  before { object.extend Hensel::Helpers  }
  subject{ object.breadcrumbs }
  it { should be_an_instance_of(Hensel::Builder) }
end
