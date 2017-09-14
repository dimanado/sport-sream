ActiveAdmin.register Merchant do
  # form do |f|
  #  f.inputs "Assign partner" do
  #    collection_select(:merchant, :partner_id, Partner.all, :id, :name)
  #  end
  #  f.actions
  # end

  index do
    column(:name)
    column(:email)
    column(:partner)
    column "Business" do |merchant|
      merchant.businesses.each do |business|
        div :class => "merchants_business" do
          link_to business.name, admin_business_path(business)
        end
      end
    end
    column(:created_at)
    actions
  end

  filter :partner
  filter :email
  filter :name
  filter :created_at
  filter :businesses_name_or_businesses_categories_name_cont, :label => "Keyword"

end
