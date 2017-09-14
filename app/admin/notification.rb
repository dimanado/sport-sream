ActiveAdmin.register Notification  do

  menu :label => proc { "Notifications (#{Notification.where(recipient_id: current_partner.id, status: 'sent').count} new)" }

  action_item :only => :index do
    if current_partner.role == "admin"
      @notification = Notification.new
      form_for @notification do |f|

        div do
          javascript_include_tag '3rd_party/jquery.multiselect.filter'
        end
        div do
          javascript_include_tag '3rd_party/jquery.multiselect.min'
        end
        div do
          stylesheet_link_tag '3rd_party/jquery.multiselect.filter'
        end
        div do
          stylesheet_link_tag '3rd_party/jquery.multiselect'
        end
        div do
          javascript_include_tag 'admin/multiselect'
        end

        div :class => 'field_send_notif_field', :id => 'notif_subject' do
          text_field_tag :subject, '', {:placeholder => "Subject"}
        end
        div :class => 'my_field_send_notif_field', :id => 'my_notif_select' do
          @people = Partner.all
          select_tag "recipient_ids", options_from_collection_for_select(@people, "id", "name"), :multiple => true, :class => "multiselect", :style => "width: 400px"
        end
        div :class => 'button_send_field' do
          button_tag(type: 'submit', :id => "send_notification") do
            content_tag(:strong, 'Send notification')
          end
        end
        div :style => "clear: both"
        div :class => 'body' do
          text_area_tag :body
        end
      end
    end
  end

  index do
    column "Notification ID" do |notification|
      link_to notification.id, admin_notification_path(notification.id)
    end
    column :subject
    column "Sender" do |notification|
      if notification.sender
        link_to "#{notification.sender.name} (#{notification.sender.email})", admin_partner_path(notification.sender)
      end
    end
    column "Recipient" do |notification|
      if notification.recipient
        link_to link_to "#{notification.recipient.name} (#{notification.recipient.email})", admin_partner_path(notification.recipient)
      end
    end

    column :status
    actions
  end

  show do
    panel "Notification Details" do
      attributes_table_for notification do
        row :created_at
        row :sender_id
        row :subject
        row :body
      end
    end
  end

  controller do
    actions :all, :except => [:new]

    def show
      if resource.status == 'sent' && resource.recipient_id == current_partner.id
        resource.update_attributes!(status: "read")
      end
      super
    end
  end

end