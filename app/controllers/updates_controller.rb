class UpdatesController < ApplicationController
  def index
    @updates = Update.find(:all, :order => "created_at DESC")
  end
end
