class AddDispatchesCounterToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :dispatches_count, :string
  end
end
