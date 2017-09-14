namespace :csv do
  
  desc "imports a CSV with merchants"
  task :import_merchants => :environment do
    file  = ENV["CSV"]
    
    CSV.foreach(file, :headers => :first_row, :encoding => 'windows-1251:utf-8') do |row|
      merchant = Merchant.new do |m|
        #build merchant
        m.name      = row['Merchant Name']
        m.email     = row['email']
        m.password  = row['password']
        m.password_confirmation = row['password']
        
        #merchant.build_business

      end#merchant
      merchant.save(:validate => false)

      zip_code = row['zip']
      zip_code = '0' + zip_code unless zip_code.size > 4

      business = Business.new do |b|
        b.merchant    = merchant
        b.name        = row['Business Name']
        b.zip_code    = zip_code
        b.city        = row['City']
        b.state       = row['State']
        b.address     = row['Street']
        b.phone       = row['phone number']
        b.categories  = [Categories.all.first]
      end
      business.save(:validate => false)

      puts "imported #{merchant}"
    end#CSV
  end#task

end