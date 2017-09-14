ActiveAdmin.register_page "Transactions" do

  content do
    columns do
      column :min_width => "1000px" do
        transactions = Transaction.all
        if not (params[:category_ids].blank? || params[:category_ids] == 'all')
          transactions = transactions.select do |t|
            t.shopping_cart_items.any? do |sci|
              if not sci.item.nil?
                not ((params[:category_ids] & sci.item.business.categories.map{|c| c.id.to_s}).empty?)
              end
            end
          end
        end

        table_for transactions do |transaction|
          column(:created_at)
          column "Consumer" do |transaction|
            if transaction.consumer.present?
              link_to transaction.consumer.email, admin_consumer_path(transaction.consumer)
            end
          end
          column(:amount)
          column(:status)

          column "Partner" do |transaction|
            if transaction.shopping_cart.present? && transaction.shopping_cart.partner.present?
              partner = transaction.shopping_cart.partner
              link_to partner.name, admin_business_path(partner)
            end
          end


          column "Offer Title" do |transaction|
            if transaction.shopping_cart.present?
              transaction.shopping_cart.shopping_cart_items.each do |sh_cart_item|
                div :class => "merchants_business" do
                  if sh_cart_item.item.present?
                    text_node sh_cart_item.item.subject
                  end
                end
              end
            end
          end

          column "Business" do |transaction|
            if transaction.shopping_cart.present?
              transaction.shopping_cart.shopping_cart_items.each do |sh_cart_item|
                div :class => "merchants_business" do
                  if sh_cart_item.item.present? && sh_cart_item.item.campaign.present? && sh_cart_item.item.campaign.business.present?
                    bsn = sh_cart_item.item.campaign.business
                    link_to bsn.name, admin_business_path(bsn)
                  end
                end
              end
            end
          end

          column "Business Category" do |transaction|
            if transaction.shopping_cart.present?
              transaction.shopping_cart.shopping_cart_items.each do |sh_cart_item|
                div :class => "merchants_business" do
                  if sh_cart_item.item.present? && sh_cart_item.item.campaign.present? && sh_cart_item.item.campaign.business.present?
                    cat_name = ''
                    bsn = sh_cart_item.item.campaign.business
                    bsn.categories.each do |categ|
                      cat_name += (categ.name + ' ')
                    end
                    text_node cat_name
                  end
                end
              end
            end
          end

          column "Business Location" do |transaction|
            if transaction.shopping_cart.present?
              transaction.shopping_cart.shopping_cart_items.each do |sh_cart_item|
                div :class => "merchants_business" do
                  if sh_cart_item.item.present? && sh_cart_item.item.campaign.present? && sh_cart_item.item.campaign.business.present?
                    text_node sh_cart_item.item.campaign.business.zip_code
                  end
                end
              end
            end
          end
        end
      end
      column :max_width => "250px" do
        panel "Filter" do
          render partial: "admin/transactions_filter"
        end
      end
    end
  end

end
