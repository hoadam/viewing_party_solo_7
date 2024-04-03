require 'rails_helper'

describe 'Admin login' do
  describe 'happy path' do
    it 'I can log in as an admin and get to my dashboard', :vcr do
      admin = User.create(name: 'Hoa', email: 'admin@gmail.com',
                          password: 'admin123', password_confirmation: 'admin123',
                          role: 1)

      visit user_login_path
      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_button 'Login'

      expect(current_path).to eq(admin_dashboard_path)
    end
  end
end

describe 'as default user' do
  it 'does not allow default user to see admin dashboard index' do
    user = User.create(name: 'Sam', email: 'sam_t@email.com',
                       password: 'sam12345', password_confirmation: 'sam12345')

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit admin_dashboard_path
    expect(page).to have_content('You are not authorized to access those pages')
  end
end
