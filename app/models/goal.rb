class Goal < ActiveRecord::Base
  validates_presence_of :user_id, :variable, :amount, :end_date
  
  belongs_to :user
end
