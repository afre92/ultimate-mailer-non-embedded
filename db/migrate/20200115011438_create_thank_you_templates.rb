class CreateThankYouTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :thank_you_templates do |t|
      t.string :from
      t.string :subject
      t.string :reply_to
      t.jsonb :body
      t.integer :shop_id
      t.text :html

      t.timestamps
    end
  end
end
