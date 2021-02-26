require "rails_helper"

describe "CheckOutモデル", type: :model do
	describe "バリデーションのテスト" do
		let(:check_out) { build(:check_out) }
		subject { check_out.valid? }

		context "return_dateカラム" do
			it "空欄でバリデートされる" do
				check_out.return_date = ""
				is_expected.to eq false
			end
		end
	end

	describe "アソシエーションのテスト" do
		context "CheckOutBookモデルとの関係" do
			it "1:Nとなっている" do
				expect(CheckOut.reflect_on_association(:check_out_books).macro).to eq :has_many
			end
		end
		context "Userモデルとの関係" do
			it "N:1となっている" do
				expect(CheckOut.reflect_on_association(:user).macro).to eq :belongs_to
			end
		end
	end
end