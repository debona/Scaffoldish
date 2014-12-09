require 'spec_helper'

require 'scaffoldish/dsl/template'


describe Scaffoldish::DSL::Template do

  class Templatable
    include Scaffoldish::DSL::Template
  end

  project_root = File.join(File.dirname(__FILE__), '..', 'fixtures', 'example')
  templates_root = File.join(project_root, 'templates')

  data = OpenStruct.new(words: 'one two three four!')
  expected_output = "The following words should be generated: one two three four!"

  before(:all) { @templetable = Templatable.new }

  before do
    Scaffoldish::Application.instance.stub(:project_root) { project_root }
    Scaffoldish::Application.instance.stub(:templates_root) { templates_root }
  end

  subject { @templetable }

  describe '#generate' do
    describe 'for an output file that does not exist' do
      output_path = File.join('to_delete', 'test', 'test.txt')
      absolute_output_path = File.join(project_root, output_path)

      before { @templetable.generate('test.txt.erb', output_path, data) }
      after { FileUtils.rm_r(File.join(project_root, 'to_delete')) }

      it 'should create necessary directories' do
        File.exist?(absolute_output_path).should == true
      end

      it 'should render the template and write the output in a file' do
        output = File.open(absolute_output_path).read
        output.chomp.should == expected_output
      end
    end

    describe 'for an output file that already exists' do
      output_path = 'test.txt'
      absolute_output_path = File.join(project_root, output_path)
      txt = "this is a unit test"

      before { File.open(absolute_output_path, 'w') { |file| file.write(txt) } }
      after { FileUtils.rm_r(absolute_output_path ) }

      it 'should not overwrite files' do
        @templetable.generate('test.txt.erb', output_path, data)

        output = File.open(absolute_output_path).read
        output.chomp.should == txt
      end
    end

  end

  describe '#chunk' do

    it 'should print the rendered template' do
      output = ""

      STDOUT.stub(:puts) { |string| output << string << "\n" }

      @templetable.chunk('test.txt.erb', 'test.txt', data)

      output.chomp.should match expected_output
    end

    it 'should print the output_path' do
      output = ""

      STDOUT.stub(:puts) { |string| output << string << "\n" }

      @templetable.chunk('test.txt.erb', 'test.txt', data)

      output.chomp.should match 'test.txt'
    end

  end
end
