require 'test_helper'

class EnhanceInstructionControllerTest < ActionController::TestCase
  def test_enhance_instruction
    get 'index'
    assert_response :success
  end
end
