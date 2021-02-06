class CheckOut < ApplicationRecord
  belongs_to :user
  has_many :check_out_books, dependent: :destroy
end
