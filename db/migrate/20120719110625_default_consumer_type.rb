class DefaultConsumerType < ActiveRecord::Migration
  def change
    Consumer.update_all :type => 'Consumer'
  end
end
