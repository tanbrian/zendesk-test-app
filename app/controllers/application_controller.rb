class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def client
    ZendeskClient.instance
  end
end

class ZendeskClient < ZendeskAPI::Client

  def self.instance 
    @instance ||= new do |config|
      config.url = ENV['ZD_URL']
      config.username = ENV['ZD_USER'] 
      config.password = ENV['ZD_PASS'] 
      config.retry = true
      config.logger = Rails.logger
    end
  end

  def tickets
    search query: "requester:#{'user@test.com'}"
  end
end