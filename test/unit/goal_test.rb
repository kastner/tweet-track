require File.dirname(__FILE__) + '/../test_helper'

context "goals" do
  specify "should find goals" do
    Goal.find(:all).should.not.be.empty
  end  
end

context "a goal" do
  setup do
    @user = users(:erik)
    @goal = goals(:erik_pushups)
  end
  
  specify "should know it's owner" do
    @goal.user.should.equal @user
  end
end