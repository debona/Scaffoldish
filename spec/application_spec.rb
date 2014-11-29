require 'spec_helper'

require 'scaffoldish/application'

describe Scaffoldish::Application do
  before(:all) do
    @app = Scaffoldish::Application.instance
  end

  before do # prevent the app to write in the console
    STDOUT.stub(:write) {}
    STDERR.stub(:write) {}
  end

  subject { @app }

  describe '.instance' do
    it { should_not be_nil }

    it 'should always return the same instance' do
      subject.should == Scaffoldish::Application.instance
    end

    its(:logger) { should be_a Logger }
    its(:scaffolds) { should be_a Hash }
    its(:workspace) { should be_a Scaffoldish::DSL::Conf }
  end

  describe '#load_config' do
    pwd = File.join(File.dirname(__FILE__), 'fixtures', 'example')
    expected_config = File.open(File.join(pwd, 'Scaffoldable')).read
    expected_scaffolfds = { expected: nil }

    before { Dir.stub(:pwd) { pwd } }
    after { @app.instance_eval { @scaffolds = {} } } # clean the app scaffolds

    it 'should eval the config file in the workspace clean room' do
      @app.workspace.should_receive(:instance_eval).with(expected_config)
      @app.load_config
    end

    it 'should apply the workspace config' do
      @app.workspace.stub(:instance_eval) # avoid to effectively load the config from file
      @app.workspace.stub(:scaffolds) { expected_scaffolfds } # manually set test config
      @app.load_config
      @app.scaffolds.should == expected_scaffolfds
    end
  end

  describe '#run' do
    context 'with an existing scaffold' do
      scaffold = Scaffoldish::Scaffold.new(:an_existing_scaffold) { |*args| args }
      before do
        @app.stub(:load_config) # shortcut load config
        @app.stub(:scaffolds) { { an_existing_scaffold: scaffold } } # manually set test config
      end
      subject { @app }

      it 'should forward the call on the scaffold' do
        parameters = [:A, :B, :C]
        scaffold.should_receive(:run).with(*parameters)
        subject.run(:an_existing_scaffold, *parameters)
      end

      describe 'output' do
        it 'should print output on stdout' do
          STDOUT.should_receive(:write).at_least(:once)
          subject.run(:an_existing_scaffold)
        end

        it 'should not print output on stderr' do
          subject.logger.should_not_receive(:error)
          subject.run(:an_existing_scaffold)
        end
      end
    end

    context 'without an existing scaffold' do
      describe 'output' do
        it 'should display an error' do
          subject.logger.should_receive(:error)
          subject.run(:non_existing_scaffold)
        end
      end
    end
  end

end
