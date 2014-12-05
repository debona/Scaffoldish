
require 'scaffoldish/dsl/template'

module Scaffoldish

  class Scaffold

    include DSL::Template

    attr_reader :name, :block

    def initialize(name, &block)
      @name  = name
      @block = block || Proc.new {}
    end

    def run(*args)
      instance_exec(*args, &block)
    end

  end

end
