class Review < ApplicationRecord
  belongs_to :order_item
  has_one :order, through: :order_item
  has_many_attached :images
  before_save :submitted_on
  enum review_status: { pending: 0, in_progress: 1,completed: 2}
  validates_presence_of :shopify_product_id
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
    first, last = self.customer_name.split(' ')
    if !last.nil?
      return "#{first} #{last.first}."
    else
      return "#{first}"
    end
  end

  def self.parse_data_and_create_review(params)
    obj = {}
    
    begin
      shop = Shop.find_by(shopify_domain: params[:shop])
      params[:review].each { |key, value| obj[value["name"]] = value["value"] }
      order = shop.orders.create(email: obj["customer_email"], customer: {id: 000, email: obj["customer_email"]})
      order_item = order.order_items.create(shopify_product_id: params["product_id"])
      review = order_item.create_review(review_status: 'completed',rating: obj["rating"], title: obj["title"], description: obj["description"], review_status: "completed", customer_name: obj["customer_name"], shopify_product_id: params["product_id"], order_item_id: order_item.id)
      raise Exception.new if review.nil? || !review.persisted?
    rescue => error
      puts error.inspect
    end
  end
end
