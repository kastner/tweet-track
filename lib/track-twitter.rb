#!/usr/local/bin/ruby

# create_table "nudges", :force => true do |t|
#   t.column "created_at", :datetime
#   t.column "user_id",    :integer
#   t.column "message",    :string
# end
# 
# create_table "tweets", :force => true do |t|
#   t.column "sent_at",    :datetime
#   t.column "sender_id",  :integer
#   t.column "tweet_id",   :integer
#   t.column "raw_text",   :string
#   t.column "created_at", :datetime
# end
# 
# create_table "updates", :force => true do |t|
#   t.column "variable",   :string
#   t.column "value",      :float
#   t.column "tweet_id",   :integer
#   t.column "user_id",    :integer
#   t.column "created_at", :datetime
# end

%w|open-uri rubygems hpricot active_record action_mailer|.each {|lib| require lib or raise "Can't load #{lib}"}

require 'irb'

ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Base.establish_connection(
  :adapter    => "mysql",
  :database   => "trackme_development",
  :username   => "root"
  # :adapter    => "sqlite3",
  # :database   => "/Users/kastner/Documents/Rails/trackme/db/development.sqlite3",
  # :timeout    => 5000
)

ActionMailer::Base.smtp_settings = {
  :domain             => "winelibrary.com",
  :perform_deliveries => true,
  :address            => 'mail.winelibrary.com',
  :port               => 25
}

class Nudger < ActionMailer::Base
  def send_nudge(to, mail_body)
    recipients to
    from %q|"Trackstat Nudger" <nudge@trackstat.us>|
    subject 'Keep going!'
    body mail_body
  end
end

class Update < ActiveRecord::Base
  belongs_to :tweet
  
  def self.count_var(var, user_id)
    connection.select_value(<<-SQL)
    SELECT sum(value)
    FROM #{self.table_name}
    WHERE 
      variable = #{self.sanitize(var)} AND
      user_id = #{self.sanitize(user_id)}
    SQL
  end
end

class Tweet < ActiveRecord::Base
  has_many :updates
end

class Nudge < ActiveRecord::Base
  def after_create
    Nudger.deliver_send_nudge("vtext.com", message)
  end
end


# IRB.start if __FILE__ == $0

url = "http://twitter.com/direct_messages.xml"

h = Hpricot::XML(open(url, :http_basic_authentication=> [user, pass]))

(h/"direct_message").each do |dm|
  tweet_id = dm.at("id").innerHTML
  sender_id = dm.at("sender_id").innerHTML
  
  # This is b/c of a bug in hpricot 0.5. It's fixed in trunk -- http://code.whytheluckystiff.net/hpricot/ticket/55
  raw_text = dm.children[3].innerHTML
  
  sent_at = dm.at("created_at").innerHTML
  
  next if Tweet.find_by_tweet_id(tweet_id) # already processed the tweet
  
  tweet = Tweet.create(:tweet_id => tweet_id, :sender_id => sender_id, :raw_text => raw_text, :sent_at => sent_at)
  
  raw_text.scan(/[\w]+:[\d\.]+/) do |couple| 
    y = couple.split(/:/)
    Update.create(:tweet => tweet, :user_id => sender_id, :variable => y[0], :value => y[1])
  end
end

# last_nudge = Nudge.find_by_user_id(627303, :order => "created_at DESC")
# if !last_nudge or (last_nudge && last_nudge.created_at < 1.hour.ago)
#   pushups = (Update.count_var("pushups", 627303) || 0).to_f
#   situps = (Update.count_var("situps", 627303) || 0).to_f
#   miles = (Update.count_var("miles", 627303) || 0).to_f
#   
#   pushups_left = (500 - pushups).to_i
#   situps_left = (500 - situps).to_i
#   miles_left = (10 - miles)
#   
#   msg = "pushups left #{pushups_left} / situps left #{situps_left} / miles left #{miles_left}!"
#   Nudge.create(:user_id => 627303, :message => msg)
# end
# 
