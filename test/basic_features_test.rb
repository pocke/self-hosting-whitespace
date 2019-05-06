require 'test_helper'

class BasicFeaturesTest < Minitest::Test
  def test_calc_add
    io = StringIO.new

    push_num io, 3
    push_num io, 8
    add io
    write_num io
    exit io
    eof io

    assert_ws "11", io
  end

  def test_calc_sub
    io = StringIO.new

    push_num io, 3
    push_num io, 8
    sub io
    write_num io
    exit io
    eof io

    assert_ws "-5", io
  end

  def test_calc_multi
    io = StringIO.new

    push_num io, 3
    push_num io, 8
    multi io
    write_num io
    exit io
    eof io

    assert_ws "24", io
  end

  def test_calc_div
    io = StringIO.new

    push_num io, 10
    push_num io, 2
    div io
    write_num io
    exit io
    eof io

    assert_ws "5", io
  end

  def test_calc_mod
    io = StringIO.new

    push_num io, 11
    push_num io, 3
    mod io
    write_num io
    exit io
    eof io

    assert_ws "2", io
  end

  # helpers

  def push_ch(io, ch)
    num_to_ws(io, ch.ord)
  end

  def push_num(io, n)
    ws = n.to_s(2).gsub('1', "\t").gsub('0', ' ')
    io.write "   #{ws}\n"
  end

  def write_num(io)
    io.write "\t\n \t"
  end

  def add(io)
    io.write "\t   "
  end

  def sub(io)
    io.write "\t  \t"
  end

  def multi(io)
    io.write "\t  \n"
  end

  def div(io)
    io.write "\t \t "
  end

  def mod(io)
    io.write "\t \t\t"
  end

  def exit(io)
    io.write("\n\n\n")
  end

  def eof(io)
    io.write('$')
  end
end
