require 'rails_helper'

RSpec.describe 'Root Page, Welcome Index', type: :feature do
  describe 'When a user visits the root path "/"' do
    before(:each) do
      @user_1 = User.create!(name: 'Sam', email: 'sam_t@email.com', password: 'sam12345',
                             password_confirmation: 'sam12345')
      @user_2 = User.create!(name: 'Tommy', email: 'tommy_t@gmail.com', password: 'tommy123',
                             password_confirmation: 'tommy123')

      visit root_path
    end

    it 'They see title of application, and link back to home page' do
      expect(page).to have_content('Viewing Party')
      expect(page).to have_link('Home')
    end

    it 'They see button to create a New User' do
      expect(page).to have_selector(:link_or_button, 'Create New User')
    end

    it 'They see button to login' do
      expect(page).to have_selector(:link_or_button, 'Login to my account')
    end

    it "They see a list of existing users, which links to the individual user's dashboard", :vcr do
      click_on 'Login to my account'
      expect(current_path).to eq(user_login_path)

      fill_in 'Email:', with: 'tommy_t@gmail.com'
      fill_in 'Password:', with: 'tommy123'
      fill_in 'Location:', with: 'Denver, CO'
      click_on 'Login'

      visit root_path

      within('#existing_users') do
        expect(page).to have_content(User.first.email)
        expect(page).to have_content(User.last.email)
      end
    end

    it 'They see a link to go back to the landing page (present at the top of all pages)' do
      expect(page).to have_link('Home')
    end
  end
end
