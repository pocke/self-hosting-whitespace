require 'minitest'
require 'minitest/autorun'

require 'pathname'
require 'forwardable'

require 'akaza'

module WhitespaceHelper
  VM_CODE = File.read(File.expand_path("../build/whitespace.ws", __dir__))

  def assert_ws(expected, input)
    input.rewind
    output = StringIO.new
    Akaza.eval(VM_CODE, input: input, output: output)
    assert_equal expected, output.string
  end
end

Minitest::Test.include WhitespaceHelper

class WhitespaceIO
  extend Forwardable

  def_delegators :@io, :rewind, :read

  def initialize
    @io = StringIO.new
  end

  def push_ch(ch)
    num_to_ws(io, ch.ord)
  end

  def push_num(n)
    ws = n.to_s(2).gsub('1', "\t").gsub('0', ' ')
    io.write "   #{ws}\n"
  end

  def write_num
    io.write "\t\n \t"
  end

  def add
    io.write "\t   "
  end

  def sub
    io.write "\t  \t"
  end

  def multi
    io.write "\t  \n"
  end

  def div
    io.write "\t \t "
  end

  def mod
    io.write "\t \t\t"
  end

  def exit
    io.write("\n\n\n")
  end

  def eof
    io.write('$')
  end

  private
  attr_reader :io
end
