
require 'fileutils'
require 'erb'

require 'scaffoldish/application'

module Scaffoldish

  module DSL

    module Template

      def generate(template_path, output_path, data)
        template = File.read(File.join(Application.instance.templates_root, template_path))
        renderer = ERB.new(template)

        result = renderer.result(data.instance_eval { binding })

        absolute_output_path = File.join(Application.instance.project_root, output_path)

        if File.exist?(absolute_output_path)
          puts("Can't generate #{absolute_output_path}, it already exists. Skip it")
          return
        end

        dir = File.dirname(absolute_output_path)
        FileUtils.mkpath(dir)

        File.open(absolute_output_path, 'w') do |file|
          file.write(result)
        end
      end

      def chunk(template_path, output_path, data)
        template = File.read(File.join(Application.instance.templates_root, template_path))
        renderer = ERB.new(template)

        result = renderer.result(data.instance_eval { binding })

        puts "Edit #{output_path}:"
        puts result
        puts ""
      end

    end

  end

end

