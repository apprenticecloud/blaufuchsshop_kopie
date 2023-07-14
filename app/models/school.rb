class School < ActiveRecord::Base
  has_many :customers, dependent: :restrict_with_error
  has_many :orders, dependent: :restrict_with_error

  belongs_to :address, dependent: :destroy

  accepts_nested_attributes_for :address


  validates :name, presence: true
  validates :address, presence: true


  def self.options_for_select
    self.all.map {|s| [s.name, s.id]}
  end

  def self.options_for_select_with_details
    self.all.map {|s| [s.name, s.id, { 'data-name' => s.name,
                                        'data-postcode' => s.address.postal_code,
                                        'data-street' => s.address.street_address,
                                        'data-locality' => s.address.address_locality }]}
  end

  def self.json
    self.all.map {|s| { 'title' => s.name,
                        'zipCode' => s.address.postal_code,
                        'streetAddress' => s.address.street_address,
                        'city' => s.address.address_locality,
                        'id' => s.id}}
  end

  def self.selectedSchool(id)
    s = self.find_by(id: id)
    {'title' => s.name,
      'zipCode' => s.address.postal_code,
      'streetAddress' => s.address.street_address,
      'city' => s.address.address_locality,
      'id' => s.id}
  end
end
