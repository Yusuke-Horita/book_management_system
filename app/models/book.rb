class Book < ApplicationRecord
	has_many :check_out_books, dependent: :destroy
	has_many :cart_items, dependent: :destroy

	validates :title, presence: true
	validates :code, presence: true
	validates :stock, presence: true, numericality: { only_integer: true }
end
