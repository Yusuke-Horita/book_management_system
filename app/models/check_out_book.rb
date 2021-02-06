class CheckOutBook < ApplicationRecord
  belongs_to :check_out
  belongs_to :book
end
