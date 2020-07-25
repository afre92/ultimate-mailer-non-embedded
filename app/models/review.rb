class Review < ApplicationRecord
  belongs_to :order_item
  has_one :order, through: :order_item
  has_many_attached :images
  before_save :submitted_on
  enum review_status: { pending: 0, in_progress: 1,completed: 2}

  # This method should only be here, where reviews are only updated when they are submitted
  def submitted_on
    self.submitted_on = DateTime.now.utc
  end

  def rating_stars(color = '#ffd700')
    total=[] 
    rating.times do |t|
      total << '★' 
    end 
    return "<span style='color:#{color};'>#{total.join('')}</span>".html_safe
  end



end
