class Order < ApplicationRecord
  belongs_to :shop
  has_many :order_items, dependent: :destroy
  has_many :emails, dependent: :destroy
end
