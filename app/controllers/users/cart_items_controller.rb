class Users::CartItemsController < ApplicationController
	before_action :authenticate_user!
	def create
		@cart_item = CartItem.new
		code = cart_item_params[:code]
		book = Book.find_by(code: code)
		if book != nil
			if !CartItem.where(user_id: current_user.id).exists?(book_id: book.id)
				@cart_item.user_id = current_user.id
				@cart_item.book_id = book.id
				@cart_item.save
				@cart_items = CartItem.where(user_id: current_user.id)
			else
				@error_message = "同一書籍の貸出は１冊までです。"
				@cart_items = CartItem.where(user_id: current_user.id)
			end
		else
			@error_message = "このコードの書籍は存在しません。"
			@cart_items = CartItem.where(user_id: current_user.id)
		end
	end

	def destroy
		@cart_item = CartItem.find(params[:id])
		@cart_item.destroy
	end

	private

	def cart_item_params
		params.require(:cart_item).permit(:code)
	end
end
