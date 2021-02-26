require 'rails_helper'

describe "CartItemモデル", type: :model do
	describe "アソシエーションのテスト" do
		context "Userモデルとの関係" do
			it "N:1となっている" do
				expect(CartItem.reflect_on_association(:user).macro).to eq :belongs_to
			end
		end
		context "Bookモデルとの関係" do
			it "N:1となっている" do
				expect(CartItem.reflect_on_association(:book).macro).to eq :belongs_to
			end
		end
	end
end