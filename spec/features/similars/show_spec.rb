require 'rails_helper'

RSpec.describe 'Similar Movies Show Page', type: :feature do
  describe 'When a user visits the similar movies show page' do
    before(:each) do
      @user = User.create!(name: 'Tommy', email: 'tommy@email.com', password: 'tommy123',
                           password_confirmation: 'tommy123')
    end

    it 'shows the similar movies to the one provided by :movie_id' do
      VCR.use_cassette('tmbd_similar_movies') do
        visit user_movie_similar_path(@user.id, '155')
        expect(page).to have_css('.similar_movie', count: 20)
      end
    end
  end
end
