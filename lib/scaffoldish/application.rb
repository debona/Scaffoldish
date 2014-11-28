require 'singleton'
require 'logger'

require 'scaffoldish/scaffold'
require 'scaffoldish/dsl/conf'

module Scaffoldish

  class Application

    include Singleton

    attr_reader :logger, :workspace
    attr_reader :scaffolds

    def initialize
      @logger = Logger.new(STDERR) # TODO: make a module with that
      @logger.level = Logger::WARN

      @workspace = Object.new
      @workspace.extend(DSL::Conf)

      @scaffolds = {}
    end

    def load_config
      config_path = "#{Dir.pwd}/Scaffoldable"
      config = File.open(config_path).read

      workspace.instance_eval(config)

      @scaffolds = workspace.scaffolds
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

    rescue Exception => e
      logger.error e
    end

  end

end
