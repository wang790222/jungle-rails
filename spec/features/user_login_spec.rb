require 'rails_helper'

RSpec.feature "Visitor navigates to login page", type: :feature, js: true do
  before :each do
    @user = User.create!(
        first_name: 'first',
        last_name: 'last',
        password: 'password',
        email: 'abc@gmail.com'
    )
  end

  scenario "They see the login page with a form" do
    # ACT
    visit root_path
    click_link 'Login'
    within('main') {expect(page).to have_content('Login')}

    fill_in 'session_email', with: 'abc@gmail.com'
    fill_in 'session_password', with: 'password'

    find(:css, ".btn-primary").click

    within('.navbar-collapse') {expect(page).to have_content('Logout')}

    # DEBUG / VERIFY
    save_screenshot
  end
end
