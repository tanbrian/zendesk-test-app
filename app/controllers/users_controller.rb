class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save

      options = { name: params[:user][:name], email: params[:user][:email],
                  verified: true }
      ZendeskAPI::User.create(client, options)

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