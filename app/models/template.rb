# frozen_string_literal: true

class Template < ApplicationRecord
  belongs_to :shop
  has_many :emails
  validate :code

  before_save :replace_quote_entities
  enum template_type: { thank_you: 0, review: 1}

  # create second validation by rendering templtae with test data?
  
  def code
    new_html = html.gsub('&quot;', '"').gsub('&ldquo;', '"').gsub('&rdquo;', '"').gsub('&lsquo;', '"').gsub('&rsquo;', '"').gsub('&lt;', '<').gsub('&gt;', '>').gsub('&nbsp;', ' ')
    elements = new_html.scan(/\{{(.*?)}}/).flatten
    non_valid = []
    elements.each do |ele|
      non_valid.push(ele) if !VALID_CODE.include?(ele.delete(" ")) 
    end
    errors.add(:invalid, " #{non_valid.join(",")} ") if non_valid.present?
  end

  def replace_quote_entities
    self.html = html.gsub('&quot;', '"').gsub('&ldquo;', '"').gsub('&rdquo;', '"').gsub('&lsquo;', '"').gsub('&rsquo;', '"').gsub('&lt;', '<').gsub('&gt;', '>').gsub('{{', '<%=').gsub('}}', '%>')
  end

  VALID_CODE = %w( customer.full_name product_name shop.email shop.address shop.owner_first_name shop.owner_last_name shop.phone shop.shop_name shop.title shop.website customer.email customer.first_name customer.last_name )
end
