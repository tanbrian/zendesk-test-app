class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      flash[:success] = 'Signed in.'
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email/password combination.'
      render 'new'
    end
  end

  def destroy
    sign_out 
    redirect_to signin_path
  end
end