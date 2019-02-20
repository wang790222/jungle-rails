class SessionsController < ApplicationController

  def new
  end

  def create
    #@session = User.find(session_params)
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      redirect_to :root
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
end
