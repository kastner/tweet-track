class User < ActiveRecord::Base
  validates_presence_of :screen_name, :twitter_id

  has_many :updates
  has_many :tweets
  has_many :goals
  has_many :active_goals, :class_name => "Goal", :conditions => "CURRENT_TIMESTAMP <= end_date"
  has_many :nudges
  has_one :last_nudge, :class_name => "Nudge", :order => "created_at DESC"
  
  def method_missing(method_id, *args, &block)
    unless match = /^count_(.+)$/.match(method_id.to_s)
      return super(method_id, *args, &block)
    end
    total_for(match[1].to_s)
  end
  
  def total_for(variable)
    self.updates.sum("value", :conditions => ["variable = ?", variable.to_s])
  end
  
  def nudgeable?
    if last_nudge
      last_nudge.created_at <= (Time.now - nudge_frequency)
    else
      nudge_frequency?
    end
  end
  
  def nudge
    active_goals.collect do |goal|
      done = total_for(goal.variable)
      left = goal.amount - done
      left = left.to_i if (left == left.to_i)
      
      "#{goal.variable} #{left}"
    end.join(" / ")
  end
end
