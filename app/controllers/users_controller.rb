class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      cookies[:user_email] = {
        value: JSON.generate({email: user_params[:email]}),
        expires: 10.days.from_now
      }
      cookies[:user_email]
      redirect_to :root
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirm)
    end
end
