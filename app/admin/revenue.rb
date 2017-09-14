ActiveAdmin.register_page "Revenue" do

	menu :label => "Revenue"

	content do
    columns do
      column :min_width => "810px" do
        revenue_total = 0
        #current_partner.merchants.each do |merchant|
          #merchant.businesses.each do |business|
            #business.campaigns.each do |campaign|
              if current_partner.role == "partner"
                partner = current_partner
                transactions = partner.shopping_cart_items_by_status("Success")
              elsif current_partner.role == "admin"
                if params[:partner].blank? || params[:partner] == 'all'

                  partner = current_partner
                  transactions = partner.all_shopping_cart_items_by_status("Success").order(created_at: :desc) #admin transactions select
                else
                  partner = Partner.find_by_slug(params[:partner])
                  transactions = partner.shopping_cart_items_by_status("Success")
                end
              end

              #Client.where("created_at >= :start_date AND created_at <= :end_date",
              #{start_date: params[:start_date], end_date: params[:end_date]})
              time_range_type = params[:time_range_type] || 'all'
              if time_range_type == 'all'
                start_date = Date.new(1998, 1, 1)
                end_date = DateTime.now
              elsif time_range_type == 'preselect'
                if params[:time] == '24h'
                  start_date = DateTime.now - 1.day
                  end_date = DateTime.now
                end
                if params[:time] == 'this_week'
                  start_date = DateTime.now.at_beginning_of_week
                  end_date = DateTime.now
                end
                if params[:time] == 'last_week'
                  start_date = 1.week.ago.beginning_of_week
                  end_date = 1.week.ago.end_of_week
                end
                if params[:time] == 'this_month'
                  start_date = DateTime.now.at_beginning_of_month
                  end_date = DateTime.now
                end
                if params[:time] == 'last_month'
                  start_date = 1.month.ago.beginning_of_month
                  end_date = 1.month.ago.end_of_month
                end
                if params[:time] == 'last_three_month'
                  start_date = 3.month.ago.beginning_of_month
                  end_date = 3.month.ago.end_of_month
                end
              elsif time_range_type == 'custom'
                if params[:start_date].blank?
                  start_date = Date.new(1998, 1, 1)
                else
                  start_date = Date.parse(params[:start_date]).beginning_of_day
                end
                if params[:end_date].blank?
                  end_date = DateTime.now
                else
                  end_date = Date.parse(params[:end_date]).end_of_day
                end
              end
              if current_partner.role == "partner"
                filtered_transactions = transactions.where(:created_at => start_date..end_date)
              elsif current_partner.role == "admin"
                filtered_transactions = transactions.where(:created_at => start_date..end_date) #admin transactions select
              end

              filtered_transactions.sort! { |a,b| b.created_at <=> a.created_at }

              table_for filtered_transactions do
                column "Date/time", :created_at
                column "Partner" do |transaction|
                  if transaction.item
                    transaction.item.partner.name
                  else "Partner info n/a"
                  end
                end
                column "Business" do |transaction|
                  if transaction.item.present?
                    transaction.item.campaign.business.name
                  end
                end
                column "Offer's name" do |transaction|
                  if transaction.item.present?
                    transaction.item.subject
                  end
                end
                #column "Transaction ID" do |transaction|
                #  transaction.shopping_cart.transaction.id
                #end
                column "Payment Processor" do |transaction|
                  text_node transaction.owner.transactions.last.payment_processor
                end
                column "Transaction ID" do |transaction|
                  if transaction.owner.transactions.last.present?
                    if transaction.owner.transactions.last.braintree_transaction_id.present?
                      text_node transaction.owner.transactions.last.braintree_transaction_id
                    elsif transaction.owner.transactions.last.paypal_transaction_id.present?
                      text_node transaction.owner.transactions.last.paypal_transaction_id
                    end
                  end
                end
                column "Amount" do |transaction|
                  transaction.quantity
                end
                column "Total $" do |transaction|
                  transaction.owner.transactions.last.amount
                end
                column "Dollarhood Revenue" do |transaction|
                  text_node "$"

                  revenue = transaction.owner.transactions.last.revenue_per_item * transaction.quantity * partner.revenue_share / 100
                  revenue = sprintf "%.2f", revenue
                  revenue = revenue.to_f
                  revenue_total += revenue
                  text_node revenue
                end
              end
            #end
          #end
        #end
      span "Total revenue: "
      text_node "$"
      text_node revenue_total.round 2
    end
    column :max_width => "250px" do
    if current_partner.role == "partner"
      panel "Date filter" do
        render partial: "admin/revenue_form", locals: { :params => params}
      end
    elsif current_partner.role == "admin"
      panel "Filter" do
        render partial: "admin/revenue_form_admin"
      end
    end
    end
    end
	end

#	index do
#		current_partner.shopping_carts.each do |cart|
#			table_for cart.transactions do |transaction|
#				column(:id)
#				column(:created_at)
#				column(:amount)
#			end
#		end
#  end

#  filter :created_at
end
