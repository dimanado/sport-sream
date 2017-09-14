class GenerateAdjustments < ActiveRecord::Migration
  def up
    Account.all.each do |a|
      a.schedule_calculate_rebate rescue false
    end
  end
end
