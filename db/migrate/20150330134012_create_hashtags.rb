class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.text :tag

      t.timestamps
    end

    create_table :coupons_hashtags, id: false do |t|
      t.belongs_to :coupon, index: true
      t.belongs_to :hashtag, index: true
    end
  end
end
