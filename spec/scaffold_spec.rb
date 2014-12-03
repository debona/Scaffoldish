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

  describe 'template related methods' do
    project_root = File.join(File.dirname(__FILE__), 'fixtures', 'example')
    templates_root = File.join(project_root, 'templates')

    data = OpenStruct.new(words: 'one two three four!')
    expected_output = "The following words should be generated: one two three four!"

    before(:all) do
      @scaffold = Scaffoldish::Scaffold.new(:scaffold_name) { }
    end

    before do
      Scaffoldish::Application.instance.stub(:project_root) { project_root }
      Scaffoldish::Application.instance.stub(:templates_root) { templates_root }
    end


    describe '#generate' do
      output_path = File.join('to_delete', 'test', 'test.txt')
      absolute_output_path = File.join(project_root, output_path)

      before { @scaffold.generate('test.txt.erb', output_path, data) }
      after { FileUtils.rm_r(File.join(project_root, 'to_delete')) }

      it 'should create necessary directories' do
        File.exist?(absolute_output_path).should == true
      end

      it 'should render the template and write the output in a file' do
        output = File.open(absolute_output_path).read
        output.chomp.should == expected_output
      end

    end

    describe '#chunk' do

      it 'should print the rendered template' do
        output = ""

        STDOUT.stub(:puts) { |string| output << string << "\n" }

        @scaffold.chunk('test.txt.erb', 'test.txt', data)

        output.chomp.should match expected_output
      end

      it 'should print the output_path' do
        output = ""

        STDOUT.stub(:puts) { |string| output << string << "\n" }

        @scaffold.chunk('test.txt.erb', 'test.txt', data)

        output.chomp.should match 'test.txt'
      end

    end
  end
end
