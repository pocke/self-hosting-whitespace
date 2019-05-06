require 'pathname'
require 'akaza'

ROOT_DIR = Pathname(__dir__)

namespace :compile do
  desc 'compile whitespace.ws.rb'
  task :whitespace do
    path = ROOT_DIR / 'whitespace.ws.rb'
    dst_path = ROOT_DIR / 'build/whitespace.ws'
    
    ws = Akaza::Ruby2ws.ruby_to_ws(File.read(path), path: path)
    File.write(dst_path, ws)
  end
end

