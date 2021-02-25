FactoryBot.define do
	factory :book do
		title { Faker::Book.title }
		code { Faker::Code.npi }
		stock { Faker::Number.number(digits: 1) }
	end
end