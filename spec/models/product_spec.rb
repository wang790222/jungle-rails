require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      @category = Category.new(name: "test_category_1")
      @category.save
      @product = Product.new(name: "test_product_1", price: 10, quantity: 50, category_id: @category.id)
      expect(@product).to be_valid
    end

    it 'is not valid without valid name' do
      @category = Category.new(name: "test_category_2")
      @category.save
      @product = Product.new(name: nil, price: 20, quantity: 40, category_id: @category.id)
      expect(@product).to_not be_valid
    end

    it 'is not valid without valid price' do
      @category = Category.new(name: "test_category_3")
      @category.save
      @product = Product.new(name: "test_product_3", price_cents: nil, quantity: 30, category_id: @category.id)
      expect(@product).to_not be_valid
    end

    it 'is not valid without valid quantity' do
      @category = Category.new(name: "test_category_4")
      @category.save
      @product = Product.new(name: "test_product_4", price: 40, quantity: nil, category_id: @category.id)
      expect(@product).to_not be_valid
    end

    it 'is not valid without valid category' do
      @category = Category.new(name: "test_category_5")
      @category.save
      @product = Product.new(name: "test_product_5", price: 50, quantity: 10, category_id: nil)
      expect(@product).to_not be_valid
    end
  end
end
