require 'twitter'

class Tweet < ActiveRecord::Base
  belongs_to :user
  has_many :updates
  
  def self.process_pms
    Twitter.find_pms("1a", "*****").each do |pm|
      next if self.find_by_tweet_id(pm.tweet_id) # already processed the tweet
      
      user = User.find_or_create_by_twitter_id_and_screen_name(pm.sender_id, pm.screen_name)
      
      tweet = user.tweets.create(
        :tweet_id   => pm.tweet_id, 
        :sender_id  => pm.sender_id, 
        :raw_text   => pm.raw_text, 
        :sent_at    => pm.sent_at
      )

      pm.raw_text.scan(/[\w]+:[\d\.]+/) do |couple| 
        y = couple.split(/:/)
        user.updates.create(
          :tweet      => tweet, 
          :variable   => y[0], 
          :value      => y[1]
        )
      end
    end
  end
end
