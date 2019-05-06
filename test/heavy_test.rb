require 'test_helper'

class HeavyTest < Minitest::Test
  BUILD_PATH = Pathname(__dir__) / '../build/'

  def test_fizzbuzz
    ws = BUILD_PATH.join('fizzbuzz.ws').read
    ws += '$' # EOF

    assert_ws "1 2 fizz 4 buzz fizz 7 8 fizz buzz 11 fizz 13 14 fizzbuzz 16 ", StringIO.new(ws)
  end
end
