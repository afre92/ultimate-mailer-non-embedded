# frozen_string_literal: true

class Template < ApplicationRecord
  belongs_to :shop
  validate :code
  # before_save :replace_quote_entities_with_escape_characters

  def code
    new_html = html.gsub('&quot;', '"').gsub('&ldquo;', '"').gsub('&rdquo;', '"').gsub('&lsquo;', '"').gsub('&rsquo;', '"').gsub('&lt;', '<').gsub('&gt;', '>').gsub('&nbsp;', ' ')
    elements = new_html.scan(/\<%(.*?)%>/).flatten
    non_valid = []
    valid_code = self.valid_code
    elements.each do |ele|
      non_valid.push(ele) if !valid_code.include?(ele.delete(" ")) 
    end
    errors.add(:invalid, " #{non_valid.join(",")} ") if non_valid.present?
  end

  # def replace_quote_entities_with_escape_characters
  #   self.html = html.gsub('&quot;', '"').gsub('&ldquo;', '"').gsub('&rdquo;', '"').gsub('&lsquo;', '"').gsub('&rsquo;', '"').gsub('&lt;', '<').gsub('&gt;', '>').gsub('&nbsp;', ' ')#.gsub('{{', '<%=').gsub('}}', '%>')
  # end

  def valid_code
    return %w( shop.email shop.address shop.owner_first_name shop.owner_last_name shop.phone shop.shop_name shop.title shop.website customer.email customer.first_name customer.last_name )
  end
end
