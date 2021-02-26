require 'rails_helper'

describe "Bookモデル", type: :model do
	describe "バリデーションのテスト" do
		let(:book) { build(:book) }
		subject { book.valid? }

		context "titleカラム" do
			it "空欄でバリデートされる" do
				book.title = ""
				is_expected.to eq false
			end
		end
		context "codeカラム" do
			it "空欄でバリデートされる" do
				book.code = ""
				is_expected.to eq false
			end
		end
		context "stockカラム" do
			it "空欄でバリデートされる" do
				book.stock = ""
				is_expected.to eq false
			end
		end
	end

	describe "アソシエーションのテスト" do
		context "CartItemモデルとの関係" do
			it "1:Nとなっている" do
				expect(Book.reflect_on_association(:cart_items).macro).to eq :has_many
			end
		end
		context "CheckOutBookモデルとの関係" do
			it "1:Nとなっている" do
				expect(Book.reflect_on_association(:check_out_books).macro).to eq :has_many
			end
		end
	end
end