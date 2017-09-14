class TargetConvertSubscribers < ActiveRecord::Migration
  def change
    Target.all.each do |t|
      t.subscribers = t.subscribers == 't' ? 'subscribed' : 'interested'
      t.save 
    end
  end
end
