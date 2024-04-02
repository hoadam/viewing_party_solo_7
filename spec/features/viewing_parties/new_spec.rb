require 'rails_helper'

RSpec.describe 'The New Viewing Party Page', type: :feature do
  describe 'When I visit the new viewing party page' do
    before(:each) do
      @user1 = User.create!(name: 'Tommy', email: 'tommy@email.com', password: 'tommy123',
                            password_confirmation: 'tommy123')
      @user2 = User.create!(name: 'Jerry', email: 'jerry@email.com', password: 'jerry123',
                            password_confirmation: 'jerry123')
      @user3 = User.create!(name: 'Elizabeth', email: 'elizabeth@email.com', password: 'lizzy123',
                            password_confirmation: 'lizzy123')
    end

    it 'shows the form to create new viewing party', vcr: { cassette_name: 'tmdb_movies' } do
      visit new_user_movie_viewing_party_path(@user1.id, '155')

      fill_in 'Duration of Party', with: 152
      fill_in 'Day', with: '03/22/24'
      fill_in 'Start Time', with: '20:00'
      fill_in 'Guest 1 Email', with: 'jerry@email.com'
      fill_in 'Guest 2 Email', with: 'elizabeth@email.com'

      click_on 'Create Party'

      expect(current_path).to eq(user_path(@user1.id))
      expect(page).to have_content('Successfully Created New Viewing Party')
      expect(page).to have_content('Movie Title: The Dark Knight')
      expect(page).to have_content('Party Time: 03/22/24 at 20:00')
      expect(page).to have_content('Tommy')
      expect(page).to have_content('Jerry')
      expect(page).to have_content('Elizabeth')
    end
  end
end
