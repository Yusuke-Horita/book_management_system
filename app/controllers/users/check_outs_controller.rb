class Users::CheckOutsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:show]
  def index
    @check_outs = CheckOut.where(user_id: current_user.id, status: false).order(created_at: :desc)
  end

  def new
    @cart_item = CartItem.new
    @check_out = CheckOut.new
    @cart_items = CartItem.where(user_id: current_user.id)
  end

  def create
    @check_out = CheckOut.new(check_out_params)
    @check_out.user_id = current_user.id
    if @check_out.save
      cart_items = CartItem.where(user_id: current_user.id)
      cart_items.each do |cart_item|
        check_out_book = CheckOutBook.new
        check_out_book.check_out_id = @check_out.id
        check_out_book.book_id = cart_item.book_id
        check_out_book.save
      end
      user = User.find(current_user.id)
      user.status = true
      user.save
      cart_items.destroy_all
      redirect_to root_path
      flash[:notice] = "貸出が完了しました"
    else
      render "new"
    end
  end

  def show
    @check_out = CheckOut.find(params[:id])
  end

  def return_page
    @check_out = CheckOut.where(user_id: current_user.id).find_by(status: true)
  end

  def destroy
    user = User.find(current_user.id)
    check_out = CheckOut.find(params[:id])
    check_out_books = check_out.check_out_books
    user.update(status: false)
    check_out.update(status: false)
    check_out_books.update_all(status: false)
    redirect_to root_path
    flash[:notice] = "返却が完了しました"
  end

  private

  def check_out_params
    params.require(:check_out).permit(:return_date)
  end

  def ensure_correct_user
    check_out = CheckOut.find(params[:id])
    if current_user != check_out.user
      redirect_to check_outs_path
    end
  end
end
