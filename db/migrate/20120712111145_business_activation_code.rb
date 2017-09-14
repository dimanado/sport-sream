class BusinessActivationCode < ActiveRecord::Migration
  def up
    add_column :businesses, :activation_code, :string

    Business.all.each do |b|
      b.generate_activation_code
      b.save
    end

    #change_column :businesses, :activation_code, :string, :null => false
  end

  def down
    remove_column :businesses, :activation_code
  end
end
