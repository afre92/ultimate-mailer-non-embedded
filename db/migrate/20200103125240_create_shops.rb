# frozen_string_literal: true

class CreateShops < ActiveRecord::Migration[5.2]
  def change
    create_table :shops do |t|
      t.string :shopify_domain, null: false
      t.string :shopify_token, null: false
      t.string :email, default: ''
      t.integer :subscription_type, default: 0
      t.float :tokens, default: 10.0

      t.timestamps
    end
  end
end
