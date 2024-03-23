require 'rails_helper'

RSpec.describe 'User Show Page', type: :feature do
  describe 'When a user visit its dashboard' do
    before(:each) do
      @user1 = User.create!(name: 'Tommy', email: 'tommy@email.com')
      @user2 = User.create!(name: 'Jerry', email: 'jerry@email.com')
      @user3 = User.create!(name: 'Elizabeth', email: 'elizabeth@email.com')

      @viewing_party_1 = ViewingParty.create!(duration: "152", date: "03/22/24", start_time: "20:00", movie_id: 155)
      @viewing_party_2 = ViewingParty.create!(duration: "130", date: "03/29/24", start_time: "21:00")

      @user_party1 = UserParty.create!(user_id: @user1.id, viewing_party_id: @viewing_party_1.id, host: true)
      @user_party2 = UserParty.create!(user_id: @user2.id, viewing_party_id: @viewing_party_1.id, host: false)

      @user_party3 = UserParty.create!(user_id: @user1.id, viewing_party_id: @viewing_party_2.id, host: true)
      @user_party4 = UserParty.create!(user_id: @user2.id, viewing_party_id: @viewing_party_2.id, host: false)
      @user_party5 = UserParty.create!(user_id: @user3.id, viewing_party_id: @viewing_party_2.id, host: false)


    end

    it "shows the details of user's viewing party" do
      VCR.use_cassette('tmdb_movies_logo') do
        visit user_path(@user1.id)

        within ".viewing_party_#{@viewing_party_1.id}" do
          expect(page).to have_content(@viewing_party_1.date)
          expect(page).to have_content(@viewing_party_1.start_time)
          expect(page).to have_content("Host: #{@user1.name}")
          expect(page).to have_content(@user2.name)
          expect(page).to have_content("Movie Title: The Dark Knight")
          expect(page).to have_css("img[src*='https://image.tmdb.org/t/p/w45/qJ2tW6WMUDux911r6m7haRef0WH.jpg']")
        end

        within ".viewing_party_#{@viewing_party_2.id}" do
          expect(page).to have_content(@viewing_party_2.date)
          expect(page).to have_content(@viewing_party_2.start_time)
          expect(page).to have_content("Host: #{@user1.name}")
          expect(page).to have_content(@user2.name)
          expect(page).to have_content(@user3.name)
        end
      end
    end
  end
end
