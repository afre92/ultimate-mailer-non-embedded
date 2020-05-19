class Email < ApplicationRecord
  belongs_to :order
  belongs_to :shop
  has_one :tracking_pixel

  enum was_sent: { not_sent: 0, sent: 1, error: 2 }
  enum email_type: { thank_you: 0, review: 1}

  attr_reader :shop, :order, :template

  def initialize(params = {})
    super
    @shop = Shop.find(@order.shop_id)
    @order = params.fetch(:order)
    @email_type = params.fetch(:email_type)
    @template = @shop.templates.find_by(template_type: @email_type)
    add_delivery_data
  end

  def add_delivery_data
    self.from = template.from
    self.subject = template.subject
    self.to = order.customer_obj.email
    self.scheduled_time = order.shopify_created_at + (@email_type == 'review' ?
       shop.review_interval.days :
        shop.thank_you_interval.minutes)
    self.html = populate_html
  end

  def parse_html(html = template.html)
    product_name = order.order_items.first.title if @email_type == 'review'
    customer = order.customer_obj
    parsed_html = ERB.new(html)
    return parsed_html.result(binding)
  end

  def populate_html
    parsed_html = ''
    if @email_type == 'thank_you'
      parsed_html = parse_html
    else
      parsed_template = parse_html
      parsed_review_form = parse_html(File.read(Rails.root + "app/views/reviews/_review_form.html.erb"))
  
      # inject review partial into template with nokogiri
      parsed_template = Nokogiri::HTML(parsed_template)
      div = parsed_template.css('div.email-row-container').last
      div.add_next_sibling(parsed_review_form)

      parsed_html = parsed_template.to_html
    end

    return parsed_html
  end
end
