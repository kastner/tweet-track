require File.dirname(__FILE__) + '/../test_helper'

context "A user with active goals" do
  setup do
    @user = users(:erik)
  end
  
  specify "should have active goals" do
    @user.active_goals.should.not.be.empty
  end
  
  specify "should make a nudge" do
    @user.nudge.should.match /pushups/
  end
  
end

context "A user with updates" do
  setup do
    @user = users(:erik)
  end
  
  specify "should be able to sum up a variable" do
    @user.total_for(:pushups).should.equal 25
  end
  
  specify "should have a cool method name for that variable" do
    @user.count_pushups.should.equal @user.total_for(:pushups)
  end 
end

context "A user" do
  setup do
    @erik = users(:erik)
    @john = users(:john)
  end
  
  specify "should know about their nudges" do
    @erik.nudges.should.not.be.empty
  end
  
  specify "should know their last nudge" do
    @erik.last_nudge.should.equal nudges(:erik_nudge)
  end
  
  specify "should return nil if there is no last nudge" do
    @john.last_nudge.should.be.nil
  end
  
  specify "should know when they're ready for a new nudge" do
    @erik.should.not.be.nudgeable
    @erik.last_nudge.update_attribute(:created_at, 1.week.ago)
    @erik.should.be.nudgeable
  end
  
  specify "should not be nudgeable without a freq set" do
    @john.should.not.be.nudgeable
  end
  
  specify "should be nudgeable even without a previous nudge" do
    @john.update_attribute(:nudge_frequency, 1.day)
    @john.should.be.nudgeable
  end
end