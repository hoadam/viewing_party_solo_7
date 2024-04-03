require 'rails_helper'

RSpec.describe 'Movie Show Page', type: :feature do
  describe 'When a user visits movie show page' do
    before(:each) do
      @user = User.create!(name: 'Tommy', email: 'tommy@email.com', password: 'tommy123',
                           password_confirmation: 'tommy123')
    end

    it 'shows 2 links to return to the Discover Page and to create a viewing party, and all the details of the movie' do
      VCR.use_cassette('tmbd_movies') do
        visit user_movie_path(@user.id, '155')
        # save_and_open_page
        expect(page).to have_link('Discover Page', href: user_discover_path(@user.id))
        expect(page).to have_link('Create Viewing Party for The Dark Knight',
                                  href: new_user_movie_viewing_party_path(@user.id, movie_id: '155'))
        expect(page).to have_content('Vote Average: 8.515')
        expect(page).to have_content('Runtime: 152')
        expect(page).to have_content('Genres: Drama, Action, Crime, Thriller')
        expect(page).to have_content('Summary Description: Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.')
        expect(page).to have_css('.cast', count: 10)
        expect(page).to have_content('Total Reviews: 13')
      end
    end
  end
end
