class Nudge < ActiveRecord::Base
  belongs_to :user
  
  def after_create
    Nudger.deliver_send_nudge(user.alert_address, message) if (user && user.alert_address)
  end
end
