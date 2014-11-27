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
  end

  describe '#run' do
    context 'with an existing scaffold' do
      scaffold = Scaffoldish::Scaffold.new(:an_existing_scaffold) { |*args| args }
      before do
        @app.stub(:scaffolds) { { an_existing_scaffold: scaffold } }
      end
      subject { @app }

      it 'should forward the call on the scaffold' do
        parameters = [:A, :B, :C]
        scaffold.should_receive(:run).with(*parameters)
        subject.run(:an_existing_scaffold, *parameters)
      end

      describe 'output' do
        it 'should print output on stdout' do
          STDOUT.should_receive(:write)
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
