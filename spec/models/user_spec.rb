require 'rails_helper'

describe "Userモデル", type: :model do
	describe "バリデーションのテスト" do
		let(:user){ build(:user) }
		subject { user.valid? }

		context "nameカラム" do
			it "空欄でバリデートされる" do
				user.name = ""
				is_expected.to eq false
			end
		end
		context "emailカラム" do
			it "空欄でバリデートされる" do
				user.email = ""
				is_expected.to eq false
			end
		end
		context "passwordカラム" do
			it "空欄でバリデートされる" do
				user.password = ""
				is_expected.to eq false
			end
		end
	end
	describe "アソシエーションのテスト" do
		context "CheckOutモデルとの関係" do
			it "1:Nとなっている" do
				expect(User.reflect_on_association(:check_outs).macro).to eq :has_many
			end
		end
		context "CartItemモデルとの関係" do
			it "1:Nとなっている" do
				expect(User.reflect_on_association(:cart_items).macro).to eq :has_many
			end
		end
	end
end