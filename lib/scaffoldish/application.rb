require 'singleton'
require 'logger'

module Scaffoldish

  class Application

    include Singleton

    CONFIG_FILE_NAME = "#{Dir.pwd}/scaffoldish/conf.rb"
    TEMPLATES_ROOT = "#{Dir.pwd}/scaffoldish/templates"

    attr_reader :logger

    def initialize
      @logger = Logger.new(STDERR) # TODO: make a module with that
      @logger.level = Logger::WARN
    end

    def run(*args)
      scaffold = args.shift

      # Parameters checking
      raise OptionParser::MissingArgument.new("$1 => scaffold_name") if scaffold.nil?

      puts "Hello world, I'm scaffoldish! Run #{scaffold}"
    rescue Exception => e
      logger.error e
    end

  end

end
