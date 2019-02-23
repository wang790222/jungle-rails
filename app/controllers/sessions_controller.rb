class SessionsController < ApplicationController

  def new
  end

  def create
    check_login
  end

  def destroy
    cookies.delete :user_email
    redirect_to :root
  end

  def check_login
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

      cookies[:user_email] = {
        value: JSON.generate({email: params[:session][:email].downcase}),
        expires: 10.days.from_now
      }
      cookies[:user_email]
      redirect_to :root
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
end
