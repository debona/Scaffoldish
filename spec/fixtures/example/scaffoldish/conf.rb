
# require 'byebug'; byebug

sccafold :endpoint do |name|
  name = name.capitalize

  data = OpenStruct.new()
  data.name = name

  # TODO Generate files with template
end

sccafold :ws do |endpoint_name, name, method_name, url_path|
  # if there is no endpoint, fail asking user to run endpoint

  name = name.capitalize
  endpoint_name = endpoint_name.capitalize
  method_name = method_name.downcase.to_sym

  data = OpenStruct.new()
  data.endpoint_name = endpoint_name
  data.name = name
  data.method_name = method_name
  data.url_path = url_path

  # TODO Generate files with template
end
