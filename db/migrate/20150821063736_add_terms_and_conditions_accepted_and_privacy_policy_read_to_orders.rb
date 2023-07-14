class AddTermsAndConditionsAcceptedAndPrivacyPolicyReadToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :terms_and_conditions_accepted, :boolean
    add_column :orders, :return_policy_read, :boolean
  end
end
