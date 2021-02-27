require 'rails_helper'

describe "管理者認証のテスト", type: :system do
	describe "管理者ログイン" do
		let(:admin) { create(:admin) }
		before do
			visit new_admin_session_path
		end

		context "ログイン画面" do
			it "ログインに成功し、会員一覧画面に遷移する" do
				fill_in "admin[email]", with: admin.email
				fill_in "admin[password]", with: admin.password
				click_button "commit"

				expect(current_path).to eq admins_books_path
			end
			it "空欄でログインに失敗する" do
				fill_in "admin[email]", with: ""
				fill_in "admin[password]", with: ""
				click_button "commit"

				expect(current_path).to eq new_admin_session_path
			end
		end
	end
end