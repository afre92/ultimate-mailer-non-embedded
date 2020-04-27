# frozen_string_literal: true

class Shop < ApplicationRecord
  has_many :templates

  enum subscription_type: { free: 0, basic: 1, pro: 2 }
end
