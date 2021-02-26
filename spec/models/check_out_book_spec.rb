require 'rails_helper'

describe "CheckOutBookモデル", type: :model do
	describe "アソシエーションのテスト" do
		context "Bookモデルとの関係" do
			it "N:1となっている" do
				expect(CheckOutBook.reflect_on_association(:book).macro).to eq :belongs_to
			end
		end
		context "CheckOutモデルとの関係" do
			it "N:1となっている" do
				expect(CheckOutBook.reflect_on_association(:check_out).macro).to eq :belongs_to
			end
		end
	end
end