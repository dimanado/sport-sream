ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    unread_messages = Notification.where(:recipient_id => current_partner.id, :status => 'sent').count
    notiications_button_class = unread_messages > 0 ? "notifications_button notifications_orange_button" : "notifications_button"

    columns do
      column do
        panel "Statistics" do
          table do
            thead do
              tr do
                th 'Total businesses'
                th 'Daily revenue:'
              end
            end
            tr do
              businesses_count = 0
              current_partner.merchants.each do |merchant|
                businesses_count += merchant.businesses.count
              end
              td "#{businesses_count}"

              revenue_total = 0
              transactions = current_partner.shopping_cart_items_by_status("Success")
              start_date = DateTime.now - 1.day
              end_date = DateTime.now
              filtered_transactions = transactions.where(:created_at => start_date..end_date)
              filtered_transactions.each do |transaction|
                revenue = transaction.owner.transactions.last.revenue_per_item * transaction.quantity * current_partner.revenue_share / 100
                revenue = sprintf "%.2f", revenue
                revenue_total += revenue.to_f
              end
              td "$#{revenue_total}"
            end
          end
        end
      end

      column do
        panel "Notifications" do
          unread_title = "You have #{unread_messages} unread messages"
          ul :class => notiications_button_class do
            li link_to unread_title, admin_notifications_path()
          end
        end
      end

      column do
        panel "Bookmarks" do
          ul do
            #'Businesses registration link: ' +
            li link_to new_merchant_registration_url(partner_slug: current_partner.slug), new_merchant_registration_url(partner_slug: current_partner.slug)
            li link_to 'Offer Board URL', categories_show_partner_url(slug: current_partner.slug, iframe: true)
          end
        end
      end
    end
  end # content

  action_item do
    link_to 'edit profile', edit_admin_partner_path(current_partner)
  end
  action_item do
    if current_partner.role == "admin"
      link_to 'Merchants', admin_merchants_path()
    end
  end
  action_item do
    if current_partner.role == "admin"
      link_to 'Partners', admin_partners_path()
    end
  end
  action_item do
    if current_partner.role == "admin"
      link_to 'Consumers', admin_consumers_path()
    end
  end
  action_item do
    if current_partner.role == "admin"
      link_to 'Referrals', admin_referrals_path()
    end
  end
end
