# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_200_204_014_509) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'review_templates', force: :cascade do |t|
    t.string 'from'
    t.string 'subject'
    t.string 'reply_to'
    t.jsonb 'body'
    t.integer 'shop_id'
    t.text 'html'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'shops', force: :cascade do |t|
    t.string 'shopify_domain', null: false
    t.string 'shopify_token', null: false
    t.string 'email', default: ''
    t.integer 'subscription_type', default: 0
    t.float 'tokens', default: 10.0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'templates', force: :cascade do |t|
    t.string 'from'
    t.string 'subject'
    t.string 'reply_to'
    t.jsonb 'body'
    t.integer 'shop_id'
    t.text 'html'
    t.integer 'template_type'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'thank_you_templates', force: :cascade do |t|
    t.string 'from'
    t.string 'subject'
    t.string 'reply_to'
    t.jsonb 'body'
    t.integer 'shop_id'
    t.text 'html'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
