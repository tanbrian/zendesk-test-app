require 'zendesk_api'
require 'json'
require 'net/http'
require 'net/https'
require 'open-uri'
require 'base64'

class TicketsController < ApplicationController
  before_action :signin_user 
  before_filter :get_current_user

  def new    
  end

  def create 
    options = { subject: params[:subject], comment: { value: params[:issue] }, 
                requester: @current_user.email, priority: 'normal' }
    if ticket_valid? options
      flash[:success] = 'Ticket created.'
      @ticket = ZendeskAPI::Ticket.create(client, options)
      redirect_to ticket_path(@ticket.id)
    else
      flash.now[:error] = 'Something went wrong. Try again.'
      render 'new'
    end
  end

  def index
    @tickets = client.tickets.fetch!(reload: true)
  end

  def show 
    @id = params[:id]
    @ticket = ZendeskAPI::Ticket.find(client, id: @id)
    @comments = client.requests.find(id: @id).comments
    @users = client.users
  end

  def update
    @id = params[:id]
    @comment_body = params[:comment]

    http_response = comment_as_end_user @id, @current_user.email, @comment_body

    redirect_to ticket_path @id
  end 

  private

  def comment_as_end_user(id, email, comment)
    uri = URI.parse "https://company167.zendesk.com/api/v2/requests/#{id}.json"
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    req = Net::HTTP::Put.new(uri.request_uri) 
    req.body = '{"request": {"comment":{"value":' + "\"#{comment}\"" + '}}}'
    req['Content-Type'] = 'application/json'
    credentials = Base64.encode64 "#{ENV['ZD_TOKEN']}"
    req.basic_auth "#{email}/token", "#{ENV['ZD_TOKEN']}"
    http.request(req)
  end

  def ticket_valid?(values)
    values.has_value?('') ? false : true
  end

  def signin_user
    if !signed_in?
      flash[:error] = 'Sign in first.'
      redirect_to signin_path
    end
  end

  def get_current_user
    @current_user = current_user
  end
end