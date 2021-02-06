class Admins::CheckOutsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @check_outs = CheckOut.where(status: true)
  end

  def show
    @check_out = CheckOut.find(params[:id])
  end
end
