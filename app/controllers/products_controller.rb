class ProductsController < ApplicationController

  def index
    @products = Product.all.order(created_at: :desc)
  end

  def show
    @product = Product.find params[:id]
    @reviews  = Review.where(product_id: params[:id]).order(created_at: :desc)
    if cookies[:user_email]
      @user_email = JSON.parse(cookies[:user_email])['email']
    end
    @has_reviewed = is_already_reviewed?
    @star_count = [0, 0, 0, 0, 0]
    @star_total = 0
    @star_average = 0.0
    @star_average_percentage = ["width:0%", "width:0%", "width:0%", "width:0%", "width:0%"]
    if @reviews.count != 0
      @reviews.each do |review|

      @star_total += review[:rating]
      case review[:rating]
        when 1
          @star_count[0] += 1
        when 2
          @star_count[1] += 1
        when 3
          @star_count[2] += 1
        when 4
          @star_count[3] += 1
        when 5
          @star_count[4] += 1
        else
          puts "Setting star_count wrong"
        end
      end
      @star_average = (@star_total / @reviews.count.to_f).round(2)

      5.times do |n|
        @star_average_percentage[n] = "width: #{@star_count[n].to_f / @reviews.count.to_f * 100}%"
      end
    end
  end

  def is_already_reviewed?
    reviewed = Review.where(product_id: params[:id], user_id: get_user_id)
    !reviewed.empty?
  end

  def get_user_id
    @user = User.where(email: @user_email)
    if @user.length > 0
      return @user[0]['id']
    else
      return 0
    end
  end
end
