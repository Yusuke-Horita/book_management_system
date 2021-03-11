require 'rails_helper'

describe "貸出・返却のテスト", type: :system do
	let(:user) { create(:user) }
	let(:book) { create(:book) }
	let(:cart_item) { create(:cart_item, user_id: user.id) }
	let(:check_out) { create(:check_out, user_id: user.id) }
	let(:check_out2) { create(:check_out, user_id: user.id, status: false)}
	let(:check_out_book) { create(:check_out_book, check_out_id: check_out.id) }
	before do
		visit new_user_session_path
		fill_in "user[email]", with: user.email
		fill_in "user[password]", with: user.password
		click_button "commit"
	end
	describe "貸出画面" do
		context "貸出画面への遷移" do
			it "遷移できる" do
				visit new_check_out_path
				expect(current_path).to eq "/check_outs/new"
			end
		end
		context "表示の確認" do
			before do
				visit new_check_out_path
			end
			it "書籍コードフォームが表示されている" do
				expect(page).to have_field "cart_item[code]"
			end
			it "返却日フォームが表示されている" do
				expect(page).to have_field "check_out[return_date]"
			end
		end
		describe "書籍コードのフォーム" do
			before do
				visit new_check_out_path
			end
			context "フォームの確認", js: true do
				let(:item) { CartItem.find_by(book_id: book.id) }

				it "追加が成功し、画面に表示される" do
					fill_in "cart_item[code]", with: book.code
					click_button "追加"
					
					expect(page).to have_content book.code
				end
				it "存在しない書籍コードで追加が失敗し、エラーメッセージが表示される" do
					book_code = Faker::Code.npi
					fill_in "cart_item[code]", with: book_code
					click_button "追加"

					expect(page).to_not have_content book_code
					expect(page).to have_content "存在しません"
				end
				it "カート追加済の書籍コードで追加が失敗し、エラーメッセージが表示される" do
					fill_in "cart_item[code]", with: cart_item.book.code
					click_button "追加"

					expect(page).to have_content "１冊までです"
				end
				it "カート内の書籍の削除ボタンをクリックすると、削除される" do
					fill_in "cart_item[code]", with: book.code
					click_button "追加"

					click_link "削除", href: "/cart_items/" + item.id.to_s
					expect(page).to_not have_content book.code
				end
			end
		end
		describe "返却日のフォーム" do
			before do
				visit new_check_out_path
			end
			context "フォームの確認" do
				it "貸出が成功し、トップページに遷移し、サクセスメッセージ・返却ボタン が表示される" do
					cart_item
					fill_in "check_out[return_date]", with: Time.current.since(7.days).strftime("%Y-%m-%d")
					click_button "貸出"

					expect(current_path).to eq "/"
					expect(page).to have_content "貸出が完了しました"
					expect(page).to have_link "返却", href: "/check_outs/return_page"
				end
				it "カート内が空の時、貸出が失敗し、エラーメッセージが表示される" do
					fill_in "check_out[return_date]", with: Time.current.since(7.days).strftime("%Y-%m-%d")
					click_button "貸出"

					expect(current_path).to eq "/check_outs"
					expect(page).to have_content "書籍を登録してください"
				end
				it "過去の日付で貸出が失敗し、エラーメッセージが表示される" do
					cart_item
					fill_in "check_out[return_date]", with: Time.current.ago(1.days).strftime("%Y-%m-%d")
					click_button "貸出"

					expect(current_path).to eq "/check_outs"
					expect(page).to have_content "過去の日付は指定できません"
				end
				it "７日後以降の日付で貸出が失敗し、エラーメッセージが表示される" do
					cart_item
					fill_in "check_out[return_date]", with: Time.current.since(8.days).strftime("%Y-%m-%d")
					click_button "貸出"

					expect(current_path).to eq "/check_outs"
					expect(page).to have_content "貸出期間は１週間までです"
				end
			end
		end
	end
	describe "返却画面" do
		before do
			check_out_book
		end
		context "返却画面への遷移" do
			it "遷移できる" do
				visit check_outs_return_page_path
				expect(current_path).to eq "/check_outs/return_page"
			end
		end
		context "表示の確認" do
			before  do
				visit check_outs_return_page_path
			end
			it "貸出中の書籍が表示されている" do
				expect(page).to have_content check_out_book.book.code
			end
			it "返却ボタンが表示されている" do
				expect(page).to have_link "返却", href: "/check_outs/" + check_out_book.check_out.id.to_s
			end
		end
		context "返却の確認" do
			before do
				visit check_outs_return_page_path
			end
			it "返却ボタンをクリックすると、返却に成功し、トップページに遷移し、サクセスメッセージ・貸出ボタンが表示される" do
				click_link "返却", href: "/check_outs/" + check_out_book.check_out.id.to_s

				# link = find('.btn-blue')
				# expect(link[:href]).to eq "/check_outs/new"
				expect(current_path).to eq "/"
				expect(page).to have_content "返却が完了しました"
				expect(page).to have_link "貸出", href: "/check_outs/new"
			end
		end
	end
	describe "貸出履歴画面" do
		context "貸出履歴画面への遷移" do
			it "遷移できる" do
				visit check_outs_path
				expect(current_path).to eq "/check_outs"
			end
		end
		context "表示の確認" do
			before do
				check_out
				check_out2
				visit check_outs_path
			end
				it "返却済の貸出の詳細画面リンクの一覧が表示されている" do
				expect(page).to have_link check_out2.created_at.to_s(:datetime_jp), href: "/check_outs/" + check_out2.id.to_s
				end
				it "貸出中の貸出の詳細画面リンクが表示されていない" do
				expect(page).to_not have_link check_out.created_at.to_s(:datetime_jp), href: "/check_outs/" + check_out.id.to_s
				end
		end
	end
end
describe "貸出履歴のテスト", type: :system do
	describe "会員" do
		let(:user) { create(:user) }
		let(:check_out) { create(:check_out, user_id: user.id) }
		let(:check_out2) { create(:check_out, user_id: user.id, status: false)}
		let(:check_out_book) { create(:check_out_book, check_out_id: check_out.id) }
		before do
			visit new_user_session_path
			fill_in "user[email]", with: user.email
			fill_in "user[password]", with: user.password
			click_button "commit"
		end
		describe "貸出履歴画面" do
			context "貸出履歴画面への遷移" do
				it "遷移できる" do
					visit check_outs_path
					expect(current_path).to eq "/check_outs"
				end
			end
			context "表示の確認" do
				before do
					check_out
					check_out2
					visit check_outs_path
				end
					it "返却済の貸出の詳細画面リンクの一覧が表示されている" do
					expect(page).to have_link check_out2.created_at.to_s(:datetime_jp), href: "/check_outs/" + check_out2.id.to_s
					end
					it "貸出中の貸出の詳細画面リンクが表示されていない" do
					expect(page).to_not have_link check_out.created_at.to_s(:datetime_jp), href: "/check_outs/" + check_out.id.to_s
					end
			end
		end
	end
	describe "管理者" do
		let(:admin) { create(:admin) }
		let(:check_out) { create(:check_out) }
		let(:check_out2) { create(:check_out, status: false) }
		let(:check_out_book) { create(:check_out_book, check_out_id: check_out.id) }
		before do
			visit new_admin_session_path
			fill_in "admin[email]", with: admin.email
			fill_in "admin[password]", with: admin.password
			click_button "commit"
		end
		describe "貸出中一覧画面" do
			context "貸出中一覧画面への遷移" do
				it "遷移できる" do
					visit admins_check_outs_path
					expect(current_path).to eq "/admins/check_outs"
				end
			end
			context "表示の確認(貸出中一覧)" do
				before do
					check_out
					check_out2
					visit admins_check_outs_path
				end
				it "貸出中の貸出の詳細画面リンクが表示されている" do
					# expect(page).to have_link check_out.created_at.to_s(:datetime_jp), href: "/admins/check_outs/" + check_out.id.to_s
					expect(page).to have_content check_out.user.name
				end
				it "返却済の貸出の詳細画面リンクが表示されていない" do
					expect(page).to_not have_link check_out2.created_at.to_s(:datetime_jp), href: "/admins/check_outs/" + check_out2.id.to_s
				end
			end
			context "表示の確認(返却済一覧)" do
				before do
					check_out
					check_out2
					visit admins_check_outs_path
					select "返却済", from: "sort"
					click_button "commit"
				end
				it "返却済の貸出の詳細画面リンクが表示されている" do
					expect(page).to have_link check_out2.created_at.to_s(:datetime_jp), href: "/admins/check_outs/" + check_out2.id.to_s
				end
				it "貸出中の貸出の詳細画面リンクが表示されていない" do
					expect(page).to_not have_link check_out.created_at.to_s(:datetime_jp), href: "/admins/check_outs/" + check_out.id.to_s
				end
			end
		end
	end
end