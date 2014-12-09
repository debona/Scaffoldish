
require 'scaffoldish/scaffold'

module Scaffoldish

  module DSL

    module Conf

      attr_accessor :scaffolds, :project_root, :templates_root

      def scaffold(name, &block)
        @scaffolds ||= {}
        @scaffolds[name.to_sym] = Scaffold.new(name.to_sym, &block)
      end

    end

  end
end
