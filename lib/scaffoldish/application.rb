require 'singleton'
require 'logger'
require 'optparse'

require 'scaffoldish/scaffold'
require 'scaffoldish/dsl/conf'

module Scaffoldish

  class Application

    include Singleton

    attr_reader :workspace
    attr_reader :scaffolds, :project_root, :templates_root

    def initialize
      @workspace = Object.new
      @workspace.extend(DSL::Conf)

      @scaffolds = {}
      @project_root = Dir.pwd
      @templates_root = File.join(@project_root, 'templates')
    end

    def load_config
      config_filename = 'Scaffoldable'
      config_path = Dir.pwd

      while config_path != '/' && !File.exist?(File.join(config_path, config_filename))
        config_path = File.expand_path("..", config_path)
      end

      config = File.read(File.join(config_path, config_filename))

      workspace.instance_eval(config)

      @scaffolds = workspace.scaffolds || @scaffolds
      @project_root = workspace.project_root || @project_root
      @templates_root = workspace.templates_root || @templates_root
    end

    def run(*args)

      load_config

      scaffold_name = args.shift

      # Parameters checking
      raise OptionParser::MissingArgument.new("$1 => scaffold_name") if scaffold_name.nil?
      unless scaffolds.has_key?(scaffold_name.to_sym)
        raise OptionParser::InvalidArgument.new("$1 => scaffold_name should be one of the followings: #{scaffolds.keys}")
      end

      scaffold = scaffolds[scaffold_name.to_sym]

      puts "Run #{scaffold_name}:"

      scaffold.run(*args)
    end

  end

end
