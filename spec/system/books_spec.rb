require 'rails_helper'

describe "書籍のテスト", type: :system do
	let(:admin) { create(:admin) }
	let(:book) { create(:book) }
	before do
		visit new_admin_session_path
		fill_in "admin[email]", with: admin.email
		fill_in "admin[password]", with: admin.password
		click_button "commit"
	end
	describe "登録画面" do
		context "登録画面への遷移" do
			it "遷移できる" do
				visit new_admins_book_path
				expect(current_path).to eq "/admins/books/new"
			end
		end
		context "表示の確認" do
			before do
				visit new_admins_book_path
			end
			it "コードフォームが表示されている" do
				expect(page).to have_field "book[code]"
			end
			it "タイトルフォームが表示されている" do
				expect(page).to have_field "book[title]"
			end
			it "在庫数フォームが表示されている" do
				expect(page).to have_field "book[stock]"
			end
		end
		context "フォームの確認" do
			before do
				visit new_admins_book_path
			end
			it "登録に成功し、サクセスメッセージが表示される" do
				fill_in "book[code]", with: Faker::Code.npi
				fill_in "book[title]", with: Faker::Book.title
				fill_in "book[stock]", with: Faker::Number.number(digits: 1)
				click_button "commit"

				expect(page).to have_content "登録されました"
			end
			it "空欄で登録に失敗し、エラーメッセージが表示される" do
				click_button "commit"

				expect(current_path).to eq "/admins/books"
				expect(page).to have_content "入力されていません"
			end
			it "既存の書籍コードで登録に失敗し、エラーメッセージが表示される" do
				fill_in "book[code]", with: book.code
				fill_in "book[title]", with: Faker::Book.title
				fill_in "book[stock]", with: Faker::Number.number(digits: 1)
				click_button "commit"

				expect(current_path).to eq "/admins/books"
				expect(page).to have_content "すでに使用されています"
			end
		end
	end
	describe "詳細画面" do
		context "詳細画面への遷移" do
			it "遷移できる" do
				visit admins_book_path(book)
				expect(current_path).to eq "/admins/books/" + book.id.to_s
			end
		end
		context "表示の確認" do
			before do
				visit admins_book_path(book)
			end
			it "コードが表示されている" do
				expect(page).to have_content book.code
			end
			it "タイトルが表示されている" do
				expect(page).to have_content book.title
			end
		end
	end
	describe "一覧画面" do
		context "一覧画面への遷移" do
			it "遷移できる" do
				visit admins_books_path
				expect(current_path).to eq "/admins/books"
			end
		end
		context "表示の確認" do
			before do
				book
				visit admins_books_path
			end
			it "コードが表示されている" do
				expect(page).to have_content book.code
			end
			it "タイトルが表示されている" do
				expect(page).to have_content book.title
			end
			it "編集リンクが表示されている" do
				expect(page).to have_link "編集", href: "/admins/books/" + book.id.to_s + "/edit"
			end
			it "削除リンクが表示されている" do
				expect(page).to have_link "削除", href: "/admins/books/" + book.id.to_s
			end
		end
		context "リンクの確認" do
			before do
				book
				visit admins_books_path
			end
			it "削除リンクをクリックすると、削除される" do
				click_link "削除", href: "/admins/books/" + book.id.to_s
				expect(current_path).to eq "/admins/books"
				expect(page).to_not have_content book.code
			end
		end
	end
	describe "編集画面" do
		context "編集画面への遷移" do
			it "遷移できる" do
				visit edit_admins_book_path(book)
				expect(current_path).to eq "/admins/books/" + book.id.to_s + "/edit"
			end
		end
		context "表示の確認" do
			before do
				visit edit_admins_book_path(book)
			end
			it "タイトルフォームが表示されている" do
				expect(page).to have_field "book[title]", with: book.title
			end
			it "在庫数フォームが表示されている" do
				expect(page).to have_field "book[stock]", with: book.stock
			end
		end
		context "フォームの確認" do
			before do
				visit edit_admins_book_path(book)
			end
			it "編集に成功し、サクセスメッセージが表示される" do
				click_button "commit"

				expect(page).to have_content "編集しました"
			end
			it "空欄で編集に失敗し、エラーメッセージが表示される" do
				fill_in "book[title]", with: ""
				fill_in "book[stock]", with: ""
				click_button "commit"

				expect(current_path).to eq "/admins/books/" + book.id.to_s
				expect(page).to have_content "入力されていません"
			end
		end
	end
end