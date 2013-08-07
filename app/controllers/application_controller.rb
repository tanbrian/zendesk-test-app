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
      config.url = "<- https://company167.zendesk.com/api/v2 ->"
      config.username = "zendesker@gmail.com"
      config.password = "zd4271"
      config.retry = true
      config.logger = Rails.logger
    end
  end

  def tickets(email)
    search query: "requester:#{email}"
  end
end