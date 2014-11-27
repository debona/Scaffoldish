require 'singleton'
require 'logger'

require 'scaffoldish/scaffold'
require 'scaffoldish/dsl/conf'

module Scaffoldish

  class Application

    include Singleton

    CONFIG_FILE_NAME = "#{Dir.pwd}/scaffoldish/conf.rb"
    TEMPLATES_ROOT = "#{Dir.pwd}/scaffoldish/templates"

    attr_reader :logger, :scaffolds, :workspace

    def initialize
      @logger = Logger.new(STDERR) # TODO: make a module with that
      @logger.level = Logger::WARN

      @scaffolds = {}
      @workspace = Object.new
      @workspace.extend(DSL::Conf)
    end

    def register_scaffold(scaffold)
      scaffolds[scaffold.name] = scaffold
    end

    def run(*args)
      scaffold_name = args.shift

      # Parameters checking
      raise OptionParser::MissingArgument.new("$1 => scaffold_name") if scaffold_name.nil?
      unless scaffolds.has_key?(scaffold_name.to_sym)
        raise OptionParser::InvalidArgument.new("$1 => scaffold_name should be one of the followings: #{scaffolds.keys}")
      end

      scaffold = scaffolds[scaffold_name.to_sym]

      puts "Run #{scaffold_name}:"

      scaffold.run(*args)

    rescue Exception => e
      logger.error e
    end

  end

end
