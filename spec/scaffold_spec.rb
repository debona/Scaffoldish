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

  describe '#generate' do
    project_root = File.join(File.dirname(__FILE__), 'fixtures', 'example')
    templates_root = File.join(project_root, 'templates')

    data = OpenStruct.new(words: 'one two three four!')
    expected_output = "The following words should be generated: one two three four!"

    before(:all) do
      @scaffold = Scaffoldish::Scaffold.new(:scaffold_name) { }
    end

    after(:all) do
      # TODO delete files
    end

    before do
      Scaffoldish::Application.instance.stub(:project_root) { project_root }
      Scaffoldish::Application.instance.stub(:templates_root) { templates_root }
    end

    it 'should create necessary directories' do
      output_path = File.join('to_delete', 'test', 'test.txt')
      absolute_output_path = File.join(project_root, output_path)

      @scaffold.generate('test.txt.erb', output_path, data)
      File.exist?(absolute_output_path).should == true

      FileUtils.rm_r(File.join(project_root, 'to_delete'))
    end

    it 'should render the template and write the output in a file' do
      absolute_output_path = File.join(project_root, 'test.txt')

      @scaffold.generate('test.txt.erb', 'test.txt', data)
      output = File.open(absolute_output_path).read
      output.chomp.should == expected_output

      File.delete(absolute_output_path)
    end

  end

end
