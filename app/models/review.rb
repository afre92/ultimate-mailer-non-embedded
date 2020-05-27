class Review < ApplicationRecord
  belongs_to :order_item
  has_one :order, through: :order_item
  before_save :submitted_on
  enum review_status: { pending: 0, completed: 1}

  # This method should only be here, where reviews are only updated when they are submitted
  def submitted_on
    self.submitted_on = DateTime.now.utc
  end
end
