require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @dylan = users(:dylan)
    @dustin = users(:dustin)
    @emily = users(:emily)
    @relationship = Relationship.new(follower_id: users(:dylan).id,
                                    followed_id: users(:dustin).id)
 end

 test "should be valid" do
   assert @relationship.valid?
 end

 test "should require a follower_id" do
   @relationship.follower_id = nil
   assert_not @relationship.valid?
 end

 test "should require a followed_id" do
   @relationship.followed_id = nil
   assert_not @relationship.valid?
 end

 test "should follow and unfollow a user" do
    assert_not @dustin.following?(@dylan)
    @dustin.follow(@dylan)
    assert @dustin.following?(@dylan)
    assert @dylan.followers.include?(@dustin)
    @dylan.unfollow(@dustin)
    assert_not @dylan.following?(@dustin)
  end

  test "activities list should have the right activities" do
    # Activities from followed user
    @emily.activity.each do |activity_following|
      assert @dylan.feed.include?(activity_following)
    end
    # Activities from self
    @dylan.activity.each do |activity_self|
      assert @dylan.feed.include?(activity_self)
    end
    # Activities from unfollowed user
    @dustin.activity.each do |activity_unfollowed|
      assert_not @dylan.feed.include?(activity_unfollowed)
    end
  end
end
