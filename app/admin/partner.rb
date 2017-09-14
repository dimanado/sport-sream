ActiveAdmin.register Partner do

  menu false

	config.per_page = 10

  index do
    column :name
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :url
    column "Merchant registration link", :id do |id|
    	link_to new_merchant_registration_url(partner_slug: Partner.find(id).slug), new_merchant_registration_url(partner_slug: Partner.find(id).slug)
    end
    column "Merchant banner link", :id do |id|
      link_to page_business_url(partner_slug: Partner.find(id).slug), page_business_url(partner_slug: Partner.find(id).slug)
    end
    column "Offer Board URL", :id do |id|
      link_to categories_show_partner_url(slug: Partner.find(id).slug, iframe: true), categories_show_partner_url(slug: Partner.find(id).slug, iframe: true)
    end
    actions
  end

  filter :email
  form do |f|
    if current_partner.role == "partner"
      f.inputs do
        f.input :name
        f.input :email
        f.input :url
        f.input :contact_info
        f.input :address
        f.input :city
        f.input :zip
        f.input :state
        f.input :phone
      end
      f.actions
    elsif current_partner.role == "admin"
      f.inputs do
        f.input :name
        f.input :email
        f.input :slug
        f.input :revenue_share
        f.input :url
        f.input :contact_info
        f.input :address
        f.input :city
        f.input :zip
        f.input :state
        f.input :phone
      end
      f.actions
    end
  end

  show do |partner|
    para do
      span "Name: "
      span partner.name
    end
    para do
      span "email: "
      span partner.email
    end
    para do
      span "Url: "
      span partner.url
    end
    para do
      span "Contact info: "
      span partner.contact_info
    end
    para do
      span "Address: "
      span partner.address
    end
    para do
      span "City: "
      span partner.city
    end
    para do
      span "ZIP: "
      span partner.zip
    end
    para do
      span "State: "
      span partner.state
    end
    para do
      span "Phone number: "
      span partner.phone
    end
    para do
      span "Merchant registration url: "
      text_node link_to new_merchant_registration_url(partner_slug: partner.slug), new_merchant_registration_url(partner_slug: partner.slug)
    end
  end

end
