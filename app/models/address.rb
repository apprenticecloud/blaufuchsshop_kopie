class Address < ActiveRecord::Base
  validates :street_address, presence: true
  validates :postal_code, presence: true
  validates :address_locality, presence: true

  has_one :school

  has_one :customer
end
