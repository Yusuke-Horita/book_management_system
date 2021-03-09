FactoryBot.define do
	factory :check_out_book do
		association :check_out
		association :book
	end
end