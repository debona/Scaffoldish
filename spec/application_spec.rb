require 'spec_helper'

require 'ostruct'

require 'scaffoldish/application'

describe Scaffoldish::Application do

  before do # prevent the app to write in the console
    # STDOUT.stub(:write) {}
    # STDERR.stub(:write) {}
  end

  describe '.instance' do
    subject { Scaffoldish::Application.instance }

    it { should_not be_nil }

    it 'should always return the same instance' do
      subject.should == Scaffoldish::Application.instance
    end

    its(:workspace) { should be_a Scaffoldish::DSL::Conf }

    describe 'defaul values' do
      its(:scaffolds) { should == {} }
      its(:project_root) { should == Dir.pwd }
      its(:templates_root) { should == File.join(Dir.pwd, 'templates') }
    end
  end

  describe '#load_config' do
    before(:all) { @app = Scaffoldish::Application.send(:new) } # work on a clean non-shared instance

    pwd = File.join(File.dirname(__FILE__), 'fixtures', 'example')
    expected_config = File.open(File.join(pwd, 'Scaffoldable')).read

    before { Dir.stub(:pwd) { pwd } }

    it 'should lookup in parent dirs until it find the config file' do
      Dir.stub(:pwd) { File.join(pwd, 'templates') }
      @app.load_config
    end

    it 'should eval the config file in the workspace clean room' do
      @app.workspace.should_receive(:instance_eval).with(expected_config)
      @app.load_config
    end

    describe 'workspace config' do
      workspace = OpenStruct.new
      settings = [
        :scaffolds,
        :project_root,
        :templates_root
      ]

      before do
        @app.stub(:workspace) { workspace }
        workspace.stub(:instance_eval) # avoid to effectively load the config from file
        settings.each { |setting| workspace[setting] = setting } # manually set test config

        @app.load_config
      end

      settings.each do |setting|
        it "should apply the #{setting} setting" do
          @app.send(setting).should_not be_nil
          @app.send(setting).should == workspace.send(setting)
        end
      end
    end
  end

  describe '#run' do
    before(:all) do
      @app = Scaffoldish::Application.send(:new) # work on a clean non-shared instance
    end

    before do
      @app.stub(:load_config) # shortcut load config
      @app.stub(:scaffolds) { { } } # manually set test config
    end

    subject { @app }

    context 'with an existing scaffold' do
      scaffold = Scaffoldish::Scaffold.new(:an_existing_scaffold) { |*args| args }
      before { @app.stub(:scaffolds) { { an_existing_scaffold: scaffold } } } # manually set test config

      it 'should forward the call on the scaffold' do
        parameters = [:A, :B, :C]
        scaffold.should_receive(:run).with(*parameters)
        subject.run(:an_existing_scaffold, *parameters)
      end
    end

    context 'with a non-existing scaffold' do
      it 'should raise a OptionParser::InvalidArgument' do
        expect { @app.run(:non_existing_scaffold) }.to raise_error(OptionParser::InvalidArgument)
      end
    end

    context 'without scaffold' do
      it 'should raise a OptionParser::MissingArgument' do
        expect { subject.run }.to raise_error(OptionParser::MissingArgument)
      end
    end
  end

end
