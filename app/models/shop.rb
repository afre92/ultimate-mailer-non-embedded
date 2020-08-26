# frozen_string_literal: true

class Shop < ApplicationRecord
  has_many :templates
  has_many :orders, dependent: :destroy
  has_one :price_rule
  has_many :reviews, through: :orders
  enum subscription_type: { free: 0, basic: 1, pro: 2 }

  def temp_session(*args)
    ShopifyAPI::Session.temp(domain: self.shopify_domain, token: self.shopify_token, api_version: '2019-10') do
      args.each do |arg|
        return method(arg).call
      end
    end
  end


  def calculate_rating(shopify_product_id)
    reviews = self.reviews.where(review_status: 'completed', shopify_product_id: shopify_product_id)
    total = 0
    reviews.each do |review|
      total += review.rating.to_i
    end
    rating = (total/reviews.count).round(1)
  end

  def create_discount_code
    discount_code = ShopifyAPI::DiscountCode.new(code: DiscountCode.create_unique_code)
    discount_code.prefix_options[:price_rule_id] = self.price_rule.shopify_id.to_i
    if discount_code.save
      self.price_rule.discount_codes.create(code: discount_code.code)
    end
    return discount_code
  end


end
