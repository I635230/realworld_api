require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "おなじタグは複数作成できない" do
    @tag1 = Tag.new(name: "new tag")
    @tag1.save
    @tag2 = Tag.new(name: "new tag")
    assert_not @tag2.valid?
  end
end
