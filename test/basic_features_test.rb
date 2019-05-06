require 'test_helper'

class BasicFeaturesTest < Minitest::Test
  def test_calc_add
    io = WhitespaceIO.new

    io.push_num 3
    io.push_num 8
    io.add
    io.write_num
    io.exit
    io.eof

    assert_ws "11", io
  end

  def test_calc_sub
    io = WhitespaceIO.new

    io.push_num 3
    io.push_num 8
    io.sub
    io.write_num
    io.exit
    io.eof

    assert_ws "-5", io
  end

  def test_calc_multi
    io = WhitespaceIO.new

    io.push_num 3
    io.push_num 8
    io.multi
    io.write_num
    io.exit
    io.eof

    assert_ws "24", io
  end

  def test_calc_div
    io = WhitespaceIO.new

    io.push_num 10
    io.push_num 2
    io.div
    io.write_num
    io.exit
    io.eof

    assert_ws "5", io
  end

  def test_calc_mod
    io = WhitespaceIO.new

    io.push_num 11
    io.push_num 3
    io.mod
    io.write_num
    io.exit
    io.eof

    assert_ws "2", io
  end

  def test_dup
    io = WhitespaceIO.new

    io.push_num 42
    io.dup
    io.write_num
    io.write_num
    io.exit
    io.eof

    assert_ws "4242", io
  end

  def test_swap
    io = WhitespaceIO.new

    io.push_num 5
    io.push_num 3
    io.swap
    io.write_num
    io.write_num
    io.exit
    io.eof

    assert_ws "53", io
  end

  def test_pop
    io = WhitespaceIO.new

    io.push_num 5
    io.push_num 3
    io.pop
    io.write_num
    io.exit
    io.eof

    assert_ws "5", io
  end

  def test_heap
    io = WhitespaceIO.new

    io.push_num 5 # addr
    io.push_num 3 # val
    io.heap_save
    io.push_num 8 # addr
    io.push_num -1 # val
    io.heap_save

    io.push_num 5
    io.heap_load
    io.write_num
    io.push_num 8
    io.heap_load
    io.write_num

    io.exit
    io.eof

    assert_ws "3-1", io
  end

  def test_io
    io = WhitespaceIO.new

    io.push_num 42
    io.push_ch '!'
    io.write_ch
    io.write_num
    io.exit
    io.eof
    assert_ws "!42", io
  end

  def test_def_call
    io = WhitespaceIO.new

    io.call "\t"
    io.exit

    io.def "\t"
    io.push_num 42
    io.write_num
    io.end

    io.eof

    assert_ws "42", io
  end
end
