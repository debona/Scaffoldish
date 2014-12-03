
require 'fileutils'

require 'scaffoldish/application'

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

    def generate(template_path, output_path, data)
      template = File.read(File.join(Application.instance.templates_root, template_path))
      renderer = ERB.new(template)

      result = renderer.result(data.instance_eval { binding })

      absolute_output_path = File.join(Application.instance.project_root, output_path)

      dir = File.dirname(absolute_output_path)
      FileUtils.mkpath(dir)

      File.open(absolute_output_path, 'w') do |file|
        file.write(result)
      end
    end

  end

end
