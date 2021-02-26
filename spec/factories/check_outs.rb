FactoryBot.define do
	factory :check_out do
		return_date { Faker::Date.between(from: Date.today, to: 7.days.since).strftime("%Y-%m-%d") }
		association :user
	end
end