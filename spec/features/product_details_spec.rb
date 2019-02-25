require 'rails_helper'

RSpec.feature "Visitor views to detail page of products", type: :feature, js: true do

  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name: Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        quantity: 10,
        price: 64.99,
        image: open_asset('apparel1.jpg')
      )
    end
  end

  scenario "They see the detail information of the product" do
    # ACT
    visit product_path(1)

    # DEBUG / VERIFY
    save_screenshot
  end

end
