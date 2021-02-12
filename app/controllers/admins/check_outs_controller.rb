class Admins::CheckOutsController < ApplicationController
  before_action :authenticate_admin!
  def index
    if params[:sort]
      @sort = params[:sort]
    else
      @sort = "貸出中"
    end

    if @sort == "貸出中"
      @check_outs = CheckOut.where(status: true).order(created_at: :desc)
    else
      @check_outs = CheckOut.where(status: false).order(created_at: :desc)
    end
  end

  def show
    @check_out = CheckOut.find(params[:id])
  end
end
