class ProductSubjectSelection < ActiveRecord::Base
  belongs_to :product
  belongs_to :subject
end
