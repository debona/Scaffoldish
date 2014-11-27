require 'singleton'
require 'logger'

require 'scaffoldish/scaffold'

module Scaffoldish

  class Application

    include Singleton

    CONFIG_FILE_NAME = "#{Dir.pwd}/scaffoldish/conf.rb"
    TEMPLATES_ROOT = "#{Dir.pwd}/scaffoldish/templates"

    attr_reader :logger, :scaffolds

    def initialize
      @logger = Logger.new(STDERR) # TODO: make a module with that
      @logger.level = Logger::WARN

      @scaffolds = {}
    end

    def run(*args)
      scaffold = args.shift

      # Parameters checking
      raise OptionParser::MissingArgument.new("$1 => scaffold_name") if scaffold.nil?
      unless scaffolds.has_key?(scaffold.to_sym)
        raise OptionParser::InvalidArgument.new("$1 => scaffold_name should be one of the followings: #{scaffolds.keys}")
      end

      puts "Hello world, I'm scaffoldish! Run #{scaffold}"
    rescue Exception => e
      logger.error e
    end

  end

end
