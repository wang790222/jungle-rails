class ReviewsController < ApplicationController
  def create
    @review = Review.new(
      :product_id => params[:review][:product_id],
      :description => params[:review][:description],
      :rating => params[:rating],
      :user_id => get_user_id
    )
    if @review.save
      puts "Review created"
    else
      puts @review.errors.messages
    end
    redirect_to :back
  end

  def get_user_id
    user_email = JSON.parse(cookies[:user_email])['email']
    @user = User.where(email: user_email)
    @user[0]['id']
  end

  def destroy
    puts "--------- params ---------"
    puts params
    puts "--------- params ---------"
    Review.find(params[:review][:id]).destroy
    redirect_to :back
  end
end
