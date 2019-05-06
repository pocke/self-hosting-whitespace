require 'pathname'
require 'akaza'
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.libs << 'test'
  test.test_files = Dir['test/**/*_test.rb']
  test.verbose = true
end

task default: [:'compile:all', :test]

ROOT_DIR = Pathname(__dir__)
DST_DIR = ROOT_DIR / 'build'
SRC_DIR = ROOT_DIR / 'src'
WS_FILES = SRC_DIR.glob('*.ws.rb')


# Compile Ruby to Whitespace
namespace :compile do
  WS_FILES.each do |ws_file|
    desc "Compile src/#{ws_file.basename} to build/#{ws_file.basename('.rb')}"
    task ws_file.basename('.ws.rb') do
      dst = DST_DIR / ws_file.basename('.rb')
      
      ws = Akaza::Ruby2ws.ruby_to_ws(ws_file.read, path: ws_file)
      File.write(dst, ws)
    end
  end

  desc "Compile all Ruby files to Whitespace"
  task all: WS_FILES.map { |w| w.basename('.ws.rb') }
end

# Run whitespace script on self-hosted interpreter
namespace :run do
  WS_FILES.each do |ws_file|
    next if ws_file.to_s.end_with?('whitespace.ws.rb')

    name = ws_file.basename('.ws.rb')

    desc "Compile src/#{ws_file.basename} to build/#{ws_file.basename('.rb')}"
    task name => ["compile:#{name}"] do
      interpreter = ROOT_DIR.join('build/whitespace.ws').read

      ws_path = DST_DIR / ws_file.basename('.rb')
      code = ws_path.read + '$'
      input = StringIO.new(code)
      Akaza.eval(interpreter, input: input)
    end
  end

  desc "Run all programs"
  task all: WS_FILES.map { |w| w.basename('.ws.rb') }

  desc 'Run self hosted hello world'
  task selfhost: [:'compile:whitespace'] do
    interpreter = ROOT_DIR.join('build/whitespace.ws').read
    input = interpreter +
      '$' +
      "   \t\t \t   \n\t\n     \t\t  \t \t\n\t\n     \t\t \t\t  \n\t\n     \t\t \t\t  \n\t\n     \t\t \t\t\t\t\n\t\n  \n\n\n" # say hello
    Akaza.eval(interpreter, input: StringIO.new(input))
  end
end
