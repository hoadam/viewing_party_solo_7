require 'rails_helper'

RSpec.describe 'Movies Index Page', type: :feature do
  describe 'When user visits movie result page' do
    before(:each) do
      @user = User.create!(name: 'Tommy', email: 'tommy@email.com', password: 'tommy123',
                           password_confirmation: 'tommy123')
    end

    it 'shows the results of 20 top rated movies' do
      VCR.use_cassette('tmbd_top_rated_movies_search') do
        visit user_movies_path(@user.id, q: 'top_rated')
        expect(page.status_code).to eq 200
        expect(page).to have_content('The Shawshank Redemption')
        expect(page).to have_content('8.704')
        expect(page).to have_css('.top_rated_movies', count: 20)
      end
    end

    it 'shows the results of 20 movies that has the keywords the user enters' do
      VCR.use_cassette('tmbd_search_movies') do
        visit user_movies_path(@user.id, q: 'titanic')
        expect(page.status_code).to eq 200
        expect(page).to have_content('Titanic')
        expect(page).to have_content('7.904')
        expect(page).to have_css('.search_movies', count: 20)
      end
    end
  end
end
