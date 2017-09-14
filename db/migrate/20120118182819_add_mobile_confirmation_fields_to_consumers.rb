class AddMobileConfirmationFieldsToConsumers < ActiveRecord::Migration
  def change
    change_table :consumers do |t|
      t.string   "mobile_confirmation_token"
      t.datetime "mobile_confirmed_at"
      t.datetime "mobile_confirmation_sent_at"
    end
  end
end
