class Review < ApplicationRecord
  belongs_to :order_item
  has_one :order, through: :order_item
  has_many_attached :images
  before_save :submitted_on
  enum review_status: { pending: 0, in_progress: 1,completed: 2}
  # validate :acceptable_image

  # This method should only be here, where reviews are only updated when they are submitted
  def submitted_on
    self.submitted_on = DateTime.now.utc
  end

  def acceptable_image
    return unless main_image.attached?
  
    unless main_image.byte_size <= 2.megabyte
      errors.add(:main_image, "is too big")
    end
  
    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(main_image.content_type)
      errors.add(:main_image, "must be a JPEG or PNG")
    end
  end

  def rating_stars(color = '#ffd700')
    total=[] 
    rating.times do |t|
      total << '★' 
    end 
    return "<span style='color:#{color};'>#{total.join('')}</span>".html_safe
  end

  def customer_name_abbreviated
    first, last = Review.last.customer_name.split(' ')
    if !last.nil?
      return "#{first} #{last.first}."
    else
      return "#{first}"
    end
    
  end


end
