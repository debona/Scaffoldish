require 'spec_helper'

require 'scaffoldish/dsl/conf'


describe Scaffoldish::DSL::Conf do

  class ConfWorkspace
    include Scaffoldish::DSL::Conf
  end

  before(:all) { @workspace = ConfWorkspace.new }
  subject { @workspace }

  describe '#scaffold' do
    expected_block = Proc.new {}

    before(:all) do
      @workspace.scaffold(:expected_name, &expected_block)
    end

    describe '#scaffolds' do
      subject { @workspace.scaffolds }

      it { should have_key :expected_name }
      its(:count) { should == 1 }

      describe 'registered scaffold' do
        subject { @workspace.scaffolds[:expected_name] }

        it { should be_a Scaffoldish::Scaffold }

        its(:name) { should == :expected_name }
        its(:block) { should == expected_block }
      end

    end
  end

  describe 'attributes' do

    it 'its project_root should be settable' do
      subject.project_root = :project_root_value
      subject.project_root.should == :project_root_value
    end

    it 'its templates_root should be settable' do
      subject.templates_root = :templates_root_value
      subject.templates_root.should == :templates_root_value
    end

  end


end
