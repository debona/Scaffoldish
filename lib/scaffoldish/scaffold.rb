
module Scaffoldish

  class Scaffold

    attr_reader :name, :block

    def initialize(name, &block)
      @name  = name
      @block = block || Proc.new {}
    end

    def run(*args)
      instance_exec(args, &block)
    end

  end

end
