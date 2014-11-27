
require 'scaffoldish/application'

module Scaffoldish

  module DSL

    module Conf

      def scaffold(name, &block)
        new_scaffold = Scaffold.new(name.to_sym, &block)
        Application.instance.register_scaffold(new_scaffold)
      end

    end

  end
end
