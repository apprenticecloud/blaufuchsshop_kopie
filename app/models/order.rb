require 'csv'
class Order < ActiveRecord::Base
  enum file_state: { not_exported: 0, exported: 1 }

  # add default order_status before creating an order
  before_validation :set_order_state, on: :create

  before_validation :set_school_address, on: :create

  # add default recipient if the order is not delivered to a school
  before_validation :set_recipient, on: :create, unless: :deliver_to_school

  belongs_to :cart, dependent: :destroy
  has_many :products, through: :cart

  belongs_to :school_address, class_name: 'Address'
  belongs_to :invoice_address, class_name: 'Address'
  belongs_to :school
  belongs_to :customer

  accepts_nested_attributes_for :cart
  accepts_nested_attributes_for :school_address
  accepts_nested_attributes_for :invoice_address

  validates :state, presence: true
  validates :state, inclusion: %w(new ready_to_ship shipped completed stopped)

  validates :email, presence: true
  validates :given_name, presence: true
  validates :family_name, presence: true
  validates :school, presence: true
  validates :cart, presence: true
  validates :recipient, presence: true

  validates :invoice_address, presence: true

  validates :school_address, presence: true

  # VALIDATE - something is ordered

  validates :terms_and_conditions_accepted, inclusion: { in: [true], message: :must_agree }

  validates :return_policy_read, inclusion: { in: [true], message: :must_read }

  def customer_name
    "#{ given_name } #{ family_name }"
  end

  def shipping_address
    deliver_to_school ? school_address : invoice_address
  end

  def active?
    deactivated_at.nil?
  end

  def deactivate!
    self.deactivated_at = DateTime.now
    self.save
  end

  def activate!
    self.deactivated_at = nil
    self.save
  end

  def weight
    weight = 0
    self.cart.positions.each do |position|
      weight += position.product.weight * position.amount
    end
    weight *= 1.05
  end

  def invoice_number
    "RN96#{"%04d" % self.id}"
  end

  def self.to_csv(orders, options = {})
    options[:col_sep] = options[:col_sep] || ';'

    CSV.generate(options) do |csv|
      csv << [
        'Name 1',
        'Name 2',
        'Name 3',
        'Adresse 1',
        'Bemerkung zur Adresse',
        'Tel.',
        'PLZ',
        'Stadt',
        'Land',
        'Absender Firma',
        'Absender Adresse 1',
        'Absender PLZ',
        'Absender Ort',
        'Absender Land',
        'Referenznr. 1',
        'Versandart',
        'Gesamtgewicht (kg)',
        'Anzahl Pakete',
        'Gewicht (kg)',
        'Kunden E-Mail',
        'Eigene E-Mail'
      ]
      orders.each do |order|
        csv_line = []

        system_email = "dpd-#{order.invoice_number}@Leustettten.de"

        if order.deliver_to_school
         csv_line << order.school.name  # Name 1
         csv_line << order.recipient  # Name 2
         csv_line << ''  # Name 3
         csv_line << order.shipping_address.street_address  # Adresse 1
         csv_line << ''  # Bemerkung zur Adresse
         csv_line << order.telephone  # Tel.
         csv_line << order.shipping_address.postal_code  # PLZ
         csv_line << order.shipping_address.address_locality  # Stadt
        else
         csv_line << ''  # Name 1
         csv_line << order.recipient  # Name 2
         csv_line << ''  # Name 3
         csv_line << order.shipping_address.street_address  # Adresse 1
         csv_line << ''  # Bemerkung zur Adresse
         csv_line << order.telephone  # Tel.
         csv_line << order.shipping_address.postal_code  # PLZ
         csv_line << order.shipping_address.address_locality  # Stadt
        end

        csv_line << 'DE'  # Land
        csv_line << 'Blaufchs Verlag'  # Absender Firma
        csv_line << 'Sonnhalde 6'  # Absender Adresse 1
        csv_line << '88699'  # Absender PLZ
        csv_line << 'Frickingen-Leutstetten'  # Absender Ort
        csv_line << 'DE'  # Absender Land
        csv_line << order.invoice_number  # Referenznr. 1
        csv_line << 'NP'  # Versandart
        csv_line << order.weight  # Gesamtgewicht (kg)
        csv_line << '1'  # Anzahl Pakete
        csv_line << ''  # Gewicht (kg)

        if order.email
          csv_line << order.email  # Kunden E-Mail
        else
          csv_line << system_email
        end

        csv_line << system_email  # Eigene E-Mail

        csv << csv_line
      end
    end
  end

  private

    def has_teacher_edition?
      self.cart.product_variants.where(teacher_edition: true).exists?
    end

    def set_order_state
      if self.notes.blank? and not has_teacher_edition?
        self.state = 'ready_to_ship'
      else
        self.state = 'new'
      end
    end

    def set_school_address
      if self.school && self.school.address
        self.build_school_address
        self.school_address.attributes = school.address.attributes.except('id')
      end
    end

    def set_recipient
      # if the order is not delivered to a school this field can be prefilled with the given name and family name of the customer
      if self.given_name && self.family_name
        self.recipient = customer_name
      end
    end
end
