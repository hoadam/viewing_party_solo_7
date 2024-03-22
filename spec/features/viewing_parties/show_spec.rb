require 'rails_helper'

RSpec.describe 'The Viewing Party Show Page', type: :feature do
  describe 'When I visit the viewing party show page' do
    before(:each) do
      @user = User.create!(name: 'Tommy', email: 'tommy@email.com')
      @viewing_party = ViewingParty.create!(duration: "152", date: "03/22/24", start_time: "20:00", movie_id: 155)
      @user_party = UserParty.create!(user_id: @user.id, viewing_party_id: @viewing_party.id, host: true)
    end

    it "has the logos of every rent/buy provider", :vcr => { cassette_name: 'buy_rent_providers_logo' } do
      visit user_movie_viewing_party_path(@user.id, "155", @viewing_party.id)

      within ".rent_providers" do
        expect(page).to have_css("img[src*='https://image.tmdb.org/t/p/w45/9ghgSC0MA082EL6HLCW3GalykFD.jpg']")
        expect(page).to have_css("img", count: 7)
      end

      within ".buy_providers" do
        expect(page).to have_css("img[src*='https://image.tmdb.org/t/p/w45/1g3ULbVMEW8OVKOJymLvfboCrMv.jpg']")
        expect(page).to have_css("img", count: 7)
      end

      expect(page).to have_content("Buy/Rent data provided by JustWatch")
    end
  end
end
