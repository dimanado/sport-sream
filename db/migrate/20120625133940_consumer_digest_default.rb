class ConsumerDigestDefault < ActiveRecord::Migration
  def change
    change_column :consumers, :weekly_digest, :boolean, :default => :true
  end
end
