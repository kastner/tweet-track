RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :active_resource ]
  
  config.load_paths += %W(#{RAILS_ROOT}/app/models/through)

  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end
  
  config.action_controller.session = { 
    :session_key => "_myapp_session", 
    :secret => "some secret phrase" 
  }
  
  # config.action_controller.session_store = :active_record_store
  # config.active_record.default_timezone = :utc
end

ActionMailer::Base.smtp_settings = {
  :domain             => "trackstat.us",
  :perform_deliveries => true,
  :address            => 'mail.winelibrary.com',
  :port               => 25
}
