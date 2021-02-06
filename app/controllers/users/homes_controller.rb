class Users::HomesController < ApplicationController
  before_action :authenticate_user!
  def top
    @user = User.find(current_user.id)
  end
end
