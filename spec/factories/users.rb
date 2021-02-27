FactoryBot.define do
	factory :user do
		email { Faker::Internet.email }
		password { Faker::Lorem.characters(number:10) }
		name { Faker::Name.name }
	end
end