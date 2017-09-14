namespace :db do
  namespace :dev do
    desc "*!!!Warning: Destructive!!!* Drops the database, runs migrations, and creates a small sample of data for development purposes"
    task :populate => :environment do
      return unless Rails.env == 'development' # Guard agains accidental execution against a production system
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:reset'].invoke
      puts 'Populating Merchant...'
      populate_merchant
      puts 'Populating Consumer...'
      populate_consumer
      puts 'Done!'
    end
  end
end

def populate_merchant
  business = Business.find_or_create_by_name(:name => "FooBar Industries",
                                             :address => "421 Napa Street",
                                             :city => "Philadelphia",
                                             :state => "PA",
                                             :zip_code => "19104",
                                             :phone => "(215)828 6161",
                                             :description => "Come in and get throuroughly FOO-ED.",
                                             :category_ids => [Category.find_by_name("Italian").id])
  merchant = Merchant.find_or_create_by_email(:email => "info@foobar.com",
                                              :password => "foobar")
  merchant.businesses << business
  merchant.save!

  account = Account.find_or_create_by_customer_reference(:customer_reference => business.id,
                                                         :merchant_id => merchant.id,
                                                         :subscription_id => "1638844")
end

def populate_consumer
  restaurants_category = Category.find_by_name("Food & Drink")
  consumer = Consumer.find_or_create_by_email(:email => 'consumer@foomail.com',
                                              :password => 'foobar',
                                              :birth_year => 30.years.ago.year,
                                              :gender => 'm',
                                              :location => '19104',
                                              :category_ids => restaurants_category.children.map(&:id) << restaurants_category.id)
end