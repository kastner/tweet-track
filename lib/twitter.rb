#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'open-uri'

module Twitter
  class PrivateMessage
    attr_accessor :tweet_id, :sender_id, :raw_text, :sent_at, :screen_name
    
    def initialize(options = {})
      options.keys.each do |key| 
        send("#{key}=", options[key]) if respond_to?("#{key}=")
      end
    end
  end
  
  def self.find_pms(user, pass)
    url = "http://twitter.com/direct_messages.xml"
    h = Hpricot::XML(open(url, :http_basic_authentication=> [user, pass]))

    (h/"direct_message").map do |dm|
      Twitter::PrivateMessage.new(
        :tweet_id     => dm.at("id").innerHTML,
        :sender_id    => dm.at("sender_id").innerHTML,
        :sent_at      => dm.at("created_at").innerHTML,
        :screen_name  => dm.at("sender_screen_name").innerHTML,
        :raw_text     => dm.children[3].innerHTML # stupid hpricot 0.5
      )
    end
  end
end