require 'rails_helper'

RSpec.describe 'Discover Movies Page', type: :feature do
  describe 'When user visits "/discover"' do
    before(:each) do
      @user = User.create!(name: 'Tommy', email: 'tommy@email.com', password: 'tommy123',
                           password_confirmation: 'tommy123')

      visit user_discover_path(@user.id)
    end

    it 'has two buttons to search for top rated movies and for the movies that have the keywords' do
      expect(page).to have_link('Find Top Rated Movies')
      expect(page).to have_field('q')
      expect(page).to have_button('Find Movies')
    end
  end
end
