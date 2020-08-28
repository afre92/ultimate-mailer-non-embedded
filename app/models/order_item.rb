
class OrderItem < ApplicationRecord
  belongs_to :order
  has_one :review
  validates_presence_of :shopify_product_id, :title

  def create_review_review_form(params)
    review = self.build_review(review_status: 'completed',rating: params["rating"], title: params["title"], description: params["description"], review_status: "completed", customer_name: params["customer_name"], shopify_product_id: params["product_id"])
    review.save
    return review
  end
end
