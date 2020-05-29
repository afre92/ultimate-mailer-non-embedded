class Order < ApplicationRecord
  belongs_to :shop
  has_many :order_items, dependent: :destroy
  has_many :reviews, through: :order_items
  has_many :emails, dependent: :destroy

  def customer_obj
    c = JSON.parse(customer, object_class: OpenStruct)
    c['full_name'] = c['default_address']['name']
    return c
  end

end
