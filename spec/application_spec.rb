require 'spec_helper'

require 'scaffoldish/application'

describe Scaffoldish::Application do
  before(:all) do
    @app = Scaffoldish::Application.instance
  end

  before { STDOUT.stub(:puts) {} }

  subject { @app }

  describe '.instance' do
    it { should_not be_nil }

    it 'should always return the same instance' do
      subject.should == Scaffoldish::Application.instance
    end

    its(:logger) { should be_a Logger }
  end

  describe '#run' do
    context 'with a scaffold' do
      subject { @app }

      it 'should print output on stdout' do
        STDOUT.should_receive(:puts)
        subject.run(:a_scaffold)
      end

      it 'should not print output on stderr' do
        STDERR.stub(:puts) {}
        STDERR.should_not_receive(:puts)
        subject.run(:a_scaffold)
      end
    end

    context 'without a scaffold' do
      it 'should display an error' do
        subject.logger.should_receive(:error)
        subject.run
      end
    end
  end

end
