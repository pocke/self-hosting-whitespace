require 'pathname'
require 'akaza'

ROOT_DIR = Pathname(__dir__)
DST_DIR = ROOT_DIR / 'build'
SRC_DIR = ROOT_DIR / 'src'

namespace :compile do
  ws_files = SRC_DIR.glob('*.ws.rb')
  ws_files.each do |ws_file|
    desc "Compile src/#{ws_file.basename} to build/#{ws_file.basename('.rb')}"
    task ws_file.basename('.ws.rb') do
      dst = DST_DIR / ws_file.basename('.rb')
      
      ws = Akaza::Ruby2ws.ruby_to_ws(ws_file.read, path: ws_file)
      File.write(dst, ws)
    end
  end

  desc "Compile all Ruby files to Whitespace"
  task all: ws_files.map { |w| w.basename('.ws.rb') }
end

