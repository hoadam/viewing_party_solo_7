class ViewingParty < ApplicationRecord
   has_many :user_parties
   has_many :users, through: :user_parties

   validates :duration, presence: true, numericality: {only_integer: true}
   validates :date, presence: true, format: { with: /\A\d{2}\/\d{2}\/\d{2}\z/, message: "should be a MM/DD/YY format"}
   validates :start_time, presence: true, format: { with: /\A\d{2}:\d{2}\z/, message: "should be a HH/MM format"}

   def find_host
      users.where("user_parties.host = true").first
   end
end
