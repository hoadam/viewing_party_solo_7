require 'rails_helper'

RSpec.describe 'Logging In' do
  it 'can log in with valid credentials', :vcr do
    user = User.create!(name: 'Tommy', email: 'tommy@gmail.com', password: 'tommy123',
                        password_confirmation: 'tommy123')

    visit user_login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on 'Login'

    expect(current_path).to eq(user_path(user))
    expect(page).to have_content("Welcome, #{user.name}")
  end

  it 'cannot log in with invalid password', :vcr do
    user = User.create!(name: 'Tommy', email: 'tommy@gmail.com', password: 'tommy123',
                        password_confirmation: 'tommy123')

    visit user_login_path

    fill_in :email, with: user.email
    fill_in :password, with: 'tommy'

    click_on 'Login'

    expect(current_path).to eq(user_login_path)
    expect(page).to have_content('Sorry, your credentials are bad')
  end

  it 'cannot log in with invalid password', :vcr do
    user = User.create!(name: 'Tommy', email: 'tommy@gmail.com', password: 'tommy123',
                        password_confirmation: 'tommy123')

    visit user_login_path

    fill_in :email, with: 'toomy@gmail.com'
    fill_in :password, with: user.password

    click_on 'Login'

    expect(current_path).to eq(user_login_path)
    expect(page).to have_content('Sorry, your credentials are bad')
  end
end
