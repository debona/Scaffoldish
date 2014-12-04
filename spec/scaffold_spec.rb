require 'spec_helper'

require 'ostruct'
require 'fileutils'

require 'scaffoldish/scaffold'

describe Scaffoldish::Scaffold do

  describe '#initialize' do
    expected_block = Proc.new { :a_bloc }
    subject { Scaffoldish::Scaffold.new(:scaffold_name, &expected_block) }

    its(:name) { should == :scaffold_name }
    its(:block) { should == expected_block }
  end

  describe '#run' do
    before(:all) do
      @scaffold = Scaffoldish::Scaffold.new(:scaffold_name) { |*args| args.join(':') }
    end
    parameters      = [:A, :B]
    expected_result = parameters.join(':')

    subject { @scaffold.run(*parameters) }

    it { should be_a String }
    it { should == expected_result }
  end

end
