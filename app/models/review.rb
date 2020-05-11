class Review < ApplicationRecord
  belongs_to :order_item
  has_one :order, through: :order_item
  enum review_status: { pending: 0, completed: 1}
end
