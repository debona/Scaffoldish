require 'spec_helper'

require 'scaffoldish/dsl/conf'


describe Scaffoldish::DSL::Conf do

  class ConfWorkspace
    include Scaffoldish::DSL::Conf
  end

  before(:all) { @workspace = ConfWorkspace.new }
  subject { @workspace }

  describe '#scaffold' do
    it 'it should register a new scaffold' do
      Scaffoldish::Application.instance.stub(:register_scaffold)
      Scaffoldish::Application.instance.should_receive(:register_scaffold)
      subject.scaffold(:new_scaffold) {}
    end
  end


end
