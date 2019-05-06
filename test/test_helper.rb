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

  # stack
  def push_ch(ch)
    push_num(ch.ord)
  end

  def push_num(n)
    ws = n.abs.to_s(2).gsub('1', "\t").gsub('0', ' ')
    sign = n < 0 ? "\t" : " "
    io.write "  #{sign}#{ws}\n"
  end

  def dup
    io.write " \n "
  end

  def swap
    io.write " \n\t"
  end

  def pop
    io.write " \n\n"
  end

  # heap
  def heap_save
    io.write "\t\t "
  end

  def heap_load
    io.write "\t\t\t"
  end

  # io
  def write_num
    io.write "\t\n \t"
  end

  def write_ch
    io.write "\t\n  "
  end

  # calc
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

  # flow
  def def(label)
    io.write("\n  #{label}\n")
  end

  def call(label)
    io.write("\n \t#{label}\n")
  end

  def jump(label)
    io.write("\n \n#{label}\n")
  end

  def jump_if_zero(label)
    io.write("\n\t #{label}\n")
  end

  def jump_if_neg(label)
    io.write("\n\t\t#{label}\n")
  end

  def end
    io.write("\n\t\n")
  end

  def exit
    io.write("\n\n\n")
  end

  # others
  def eof
    io.write('$')
  end

  private
  attr_reader :io
end
