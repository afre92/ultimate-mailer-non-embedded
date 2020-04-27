task add_tokens_to_active_accounts: :environment do  
  # 1 check on billing_on stored in shops table
  shops = Shop.where(billing_on: Date.today) # check on the day of the month instead of the whole date and subscription type not 0
  
  # 2 if today then init session and check on the status of obj
  shops.each do |shop|

    payment_status = ShopifyAPI::Session.temp(domain: shop.shopify_domain, token: shop.shopify_token, api_version: "2020-01") do
      ShopifyAPI::RecurringApplicationCharge.find(shop.charge_id).status
    end
    
    # 3 if status active then add the tokens
    if payment_status == 'active'

      if shop.subscription_type == "pro"
        # add tokens for pro
        shop.update(tokens: shop.tokens + 10000.00)
      elsif shop.subscription_type == "basic"
        # add tokens for basic
        shop.update(tokens: shop.tokens + 5000.00)
      end
    end
  end
end

# v 1.1
# 1 check on billing_on stored in shops table
# 2 if today then init session and check on the status of obj
# 3 if status active then add the tokens