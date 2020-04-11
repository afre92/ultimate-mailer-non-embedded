class Email < ApplicationRecord
  has_many :templates
  has_one :review
end
