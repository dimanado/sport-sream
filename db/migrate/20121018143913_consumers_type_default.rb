class ConsumersTypeDefault < ActiveRecord::Migration
  def change
    change_column :consumers, :type, :string, :null => false, :default => 'Consumer'
  end
end
