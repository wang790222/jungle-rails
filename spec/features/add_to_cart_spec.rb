require 'rails_helper'

RSpec.feature "Visitor navigates to cart page", type: :feature, js: true do
  before :each do
    @category = Category.create! name: 'Apparel'
    @category.products.create!(
      name: Faker::Hipster.sentence(3),
      description: Faker::Hipster.paragraph(4),
      quantity: 10,
      price: 64.99,
      image: open_asset('apparel1.jpg')
    )
  end

  scenario "They see all their products in the cart" do
    # ACT
    visit root_path
    within find('.products') do
      find(".fa-shopping-cart").click
    end

    # DEBUG / VERIFY
    save_screenshot
  end
end
