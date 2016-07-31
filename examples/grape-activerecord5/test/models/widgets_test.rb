require_relative '../test_helper'

class WidgetsTest < TestCase
  def test_update
    widget = widgets(:a)
    widget.name = 'Widget B'
    assert widget.save
  end
end
