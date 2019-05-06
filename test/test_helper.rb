require 'minitest'
require 'minitest/autorun'

require 'pathname'

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
