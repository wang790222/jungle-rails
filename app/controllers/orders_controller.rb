require 'sendgrid-ruby'
include SendGrid

class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
    @order_result = get_order_detail(params[:id])
  end

  def create
    charge = perform_stripe_charge
    order  = create_order(charge)

    if order.valid?
      empty_cart!
      send_email_receipt(order.id)
      redirect_to order, notice: 'Your Order has been placed.'
    else
      redirect_to cart_path, flash: { error: order.errors.full_messages.first }
    end

  rescue Stripe::CardError => e
    redirect_to cart_path, flash: { error: e.message }
  end

  private

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      cart_subtotal_cents,
      description: "Yu-Ning's Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge)
    order = Order.new(
      email: params[:stripeEmail],
      total_cents: cart_subtotal_cents,
      stripe_charge_id: stripe_charge.id, # returned by stripe
    )

    enhanced_cart.each do |entry|
      product = entry[:product]
      quantity = entry[:quantity]
      order.line_items.new(
        product: product,
        quantity: quantity,
        item_price: product.price,
        total_price: product.price * quantity
      )
    end
    order.save!
    order
  end

  def get_order_detail(order_id)
     sql = "select line_items.*, products.name, products.description, products.image from line_items inner join products on line_items.product_id = products.id where line_items.order_id = #{order_id};"
     ActiveRecord::Base.connection.execute(sql)
  end

  def send_email_receipt(order_id)
    user_email = JSON.parse(cookies[:user_email])['email']
    @order_result = get_order_detail(order_id)
    temp_total = 0

    mail_content = "Your order detail:<br>"
    @order_result.each do |item|
      mail_content += "&nbsp;&nbsp;Item: #{item['name']}, Qty: #{item['quantity']} <br>"
      temp_total += item['total_price_cents'].to_i
    end
    mail_content += "total: #{temp_total / 100.0}"

    from = Email.new(email: ENV['VALID_EMAIL_ACCOUNT'])
    to = Email.new(email: user_email)
    subject = "Thanks for you order - ##{order_id}!"
    content = Content.new(type: 'text/html', value: mail_content)
    mail = SendGrid::Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])

    response = sg.client.mail._('send').post(request_body: mail.to_json)
    # puts response.status_code
    # puts response.body
    # puts response.headers
  end
end
