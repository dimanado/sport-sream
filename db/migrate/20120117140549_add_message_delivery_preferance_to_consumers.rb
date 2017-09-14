class AddMessageDeliveryPreferanceToConsumers < ActiveRecord::Migration
  def change
    add_column :consumers, :message_delivery_preference, :string, :default => "#{DeliveryChannel::Email}", :null => false
  end
end
