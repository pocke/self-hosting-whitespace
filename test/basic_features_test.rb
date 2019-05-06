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
end
