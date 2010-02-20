require File.join(File.dirname(__FILE__), '/../../test_helper')

class YandexServerSearchEngineTest < ActiveSupport::TestCase

  test "Should be able to create new instance of a portlet" do
    assert YandexServerSearchEnginePortlet.create!(:name => "New Portlet")
  end



  test "Path attribute can be set in constructor" do
    portlet = YandexServerSearchEnginePortlet.create!(:name=>"Engine", :path => "/engine")
    assert_equal "/engine", portlet.path
  end
end