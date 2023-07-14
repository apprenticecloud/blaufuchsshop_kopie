class User < ActiveRecord::Base
#  after_initialize :set_default_values
#  after_create :create_customer

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :customer, inverse_of: :user

  has_many :orders, through: :customer, dependent: :restrict_with_error

  validates :role, presence: true

  validates :role, inclusion: %w(student teacher admin printery)

  validate :customer_is_present

  accepts_nested_attributes_for :customer, reject_if: :not_a_customer

  scope :admin_panel_users, -> { where('role IN (?)', ['admin', 'printery']) }

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

  # override devise method for log in
  def active_for_authentication?
    super and self.active?
  end

  def customer_is_present
    if user_is_customer && customer.nil?
      errors.add(:customer, I18n.t('errors.messages.blank'))
    end
  end

 # private
    def user_is_customer
      if role && ['student', 'teacher'].include?(role)
        true
      else
        false
      end
    end

    def not_a_customer
      if role && !(['student', 'teacher'].include?(role))
        true
      else
        false
      end
    end

#    def set_default_values
#      self.role ||= 'customer'
#    end

#    def create_customer
#      if role == 'customer' || role == 'teacher' || role == 'student'
#        Customer.create! user_id: id
#      end
#    end
end
