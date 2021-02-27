require 'rails_helper'

describe "会員認証のテスト", type: :system do
	describe "会員新規登録" do
		before do
			visit new_user_registration_path
		end
		context "新規登録画面" do
			it "新規登録に成功し、トップページに遷移する" do
				fill_in "user[name]", with: Faker::Name.name
				fill_in "user[email]", with: Faker::Internet.email
				fill_in "user[password]", with: "password"
				fill_in "user[password_confirmation]", with: "password"
				click_button "commit"
				
				expect(current_path).to eq "/"
			end
			it "空欄で新規登録に失敗し、エラーメッセージが表示される" do
				click_button "commit"

				expect(current_path).to eq "/users"
				expect(page).to have_content "入力されていません"
			end
		end
	end
	describe "会員ログイン" do
		let(:user) { create(:user) }
		before do
			visit new_user_session_path
		end
		context "ログイン画面" do
			it "ログインに成功し、トップページに遷移する" do
				fill_in "user[email]", with: user.email
				fill_in "user[password]", with: user.password
				click_button "commit"

				expect(current_path).to eq "/"
			end
			it "空欄でログインに失敗する" do
				click_button "commit"

				expect(current_path).to eq "/users/sign_in"
			end
		end
	end
end