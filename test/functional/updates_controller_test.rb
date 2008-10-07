require File.dirname(__FILE__) + '/../test_helper'
require 'updates_controller'

# Re-raise errors caught by the controller.
class UpdatesController; def rescue_action(e) raise e end; end

class UpdatesControllerTest < Test::Unit::TestCase
  def setup
    @controller = UpdatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
