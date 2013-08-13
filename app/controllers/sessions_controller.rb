require 'jwt'

class SessionsController < ApplicationController

  ZENDESK_SUBDOMAIN = ENV['ZENDESK_SUBDOMAIN']
  ZENDESK_SHARED_SECRET = ENV['ZENDESK_SHARED_SECRET']

  def new
    if signed_in?
      sign_out
      flash.now[:success] = 'Logged out.'
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

      sign_into_zendesk user

      sign_in user
      flash[:success] = 'Signed in.'
      #redirect_to root_path
    else
      flash.now[:error] = 'Invalid email/password combination.'
      render 'new'
    end
  end

  def destroy
    sign_out 
    redirect_to signin_path
  end

  private

  def sign_into_zendesk(user)
    iat = Time.now.to_i
    jti = "#{iat}/#{rand(36**64).to_s(36)}"

    payload = JWT.encode({ iat: iat, jti: jti, 
                name: user.name, email: user.email}, ZENDESK_SHARED_SECRET)

    redirect_to zendesk_sso_url(payload)
  end

  def zendesk_sso_url(payload)
    "https://#{ZENDESK_SUBDOMAIN}.zendesk.com/access/jwt?jwt=#{payload}&return_to=http://localhost:3000/"
  end
end