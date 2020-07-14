class DiscountCode < ApplicationRecord
  belongs_to :price_rule

  def self.create_unique_code
    loop do
      random_code = SecureRandom.urlsafe_base64(nil, false)[0...6]
      return random_code unless DiscountCode.exists?(code: random_code)
    end
  end
end