require 'singleton'
require 'logger'

module Scaffolder

  class Application

    include Singleton

    attr_reader :logger

    def initialize
      @logger = Logger.new(STDERR) # TODO: make a module with that
      @logger.level = Logger::WARN
    end

    def run(command_file, *parameters)

    rescue Exception => e
      logger.error e
    end

  end

end
