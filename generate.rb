
require 'trollop'
require 'erb'
require 'json'

$opts = Trollop::options do
  opt :data_file, "JSON formatted file", required: true, type: :string, short: '-d'
  opt :template, "ERB formatted template", required: true, type: :string, short: '-t'
  opt :out_file, "Output MD file", required: false, type: :string, short: '-o', default: './out.md'
end

def generate(data, template)
  title = "Food"
  categories = data['categories']
  renderer = ERB.new(template, nil, '-')
  renderer.result(binding)
end

begin
  data = JSON.parse(File.read($opts[:data_file]))
  template = File.read($opts[:template])
  rendered = generate(data, template)
  File.write($opts[:out_file], rendered)
rescue JSON::ParserError => e
  $stderr.puts "ERROR: could not parse JSON file #{$opts[:data_file]}, #{e.message}"
  exit 1
rescue Errno::ENOENT, Errno::EACCES => e
  $stderr.puts "ERROR: file is unreadable, #{e.message}"
  exit 1
rescue Exception => e
  $stderr.puts "ERROR: #{e.class}, #{e.message}"
  exit 1
end
