FactoryBot.define do
	factory :cart_item do
		association :user
		association :book
	end
end