class Customer < ActiveRecord::Base
  has_many :orders, dependent: :restrict_with_error

  belongs_to :address, dependent: :destroy
  belongs_to :user, inverse_of: :customer
  belongs_to :cart, dependent: :destroy
  belongs_to :school

  validates :school, presence: true

  accepts_nested_attributes_for :address
end
