class Admins::BooksController < ApplicationController
  before_action :authenticate_admin!
  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    code = book_params[:code]
    if !Book.exists?(code: code)
      if @book.save
        redirect_to admins_book_path(@book)
        flash[:notice] = "書籍が登録されました"
      else
        render "new"
      end
    else
      @exists_error = "コード#{code}はすでに使用されています。"
      render "new"
    end
  end

  def show
    @book = Book.find(params[:id])
    @number_on_loans = CheckOutBook.where(book_id: @book.id, status: true).size
    @stock = @book.stock - @number_on_loans
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to admins_book_path(@book)
      flash[:notice] = "書籍を編集しました"
    else
      render "edit"
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to admins_books_path
    flash[:notice] = "書籍を削除しました"
  end

  private

  def book_params
    params.require(:book).permit(:title, :code, :stock)
  end
end
