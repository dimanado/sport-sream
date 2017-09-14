class ConsumerNoNilType < ActiveRecord::Migration
  def change
    Consumer.where(:type => nil).update_all(:type => 'Consumer')
  end
end
