class AddImportedByToConsumers < ActiveRecord::Migration
  def change
    transaction do
      Business.all.each do |b|
        b.private_subscribers.each do |ps|
          ps.imported_by = b.id
          ps.save
        end
      end
    end
  end
end
