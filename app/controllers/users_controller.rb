require 'zendesk_api'
require 'json'
require 'net/http'
require 'net/https'
require 'open-uri'

class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save

      options = { name: params[:user][:name], email: params[:user][:email], 
                  verified: true }
      @new_user = ZendeskAPI::User.create(client, options)
      @id = @new_user.id

      uri = URI.parse "https://#{ENV['ZD_DOMAIN']}.zendesk.com/api/v2/users/#{@id}/password.json"
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      req = Net::HTTP::Put.new uri.request_uri
      req.body = '{"password":' + "\"#{params[:user][:password]}\"" +'}'
      req['Content-Type'] = 'application/json'
      req.basic_auth ENV['ZD_USER'], ENV['ZD_PASS']
      response = http.request req

      sign_in @user
      flash[:success] = 'Welcome! Now make a ticket!'
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
  end

end