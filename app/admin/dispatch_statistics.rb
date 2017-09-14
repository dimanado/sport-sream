ActiveAdmin.register_page "Dispatch Statistics" do

  # Menu
  menu parent: "materials", priority: 91

  content do
    columns do
      column :min_width => "810px" do
        if params[:partner_id].blank? || params[:partner_id] == 'all'
          partners = Partner.all()
        else
          partners = Partner.find_by_id(params[:partner_id])
        end

        text_node "Dispatches by partner"
        table_for partners do |partner|
          column "Partner Name" do |partner|
            link_to partner.name, admin_partner_path(partner)
          end
          column "Partner Email" do |partner|
            text_node partner.email
          end
          column "Dispatches Count" do |partner|
            text_node partner.dispatches.count
          end
          column "Registered Merchants Count" do |partner|
            text_node DispatchRecipient.joins(:dispatch).where("dispatches.partner_id = #{partner.id} AND status = 'confirmed'").select(:email).uniq.count
          end
        end

        dispatches = Dispatch.all()
        if params[:partner_id] != 'all' && !params[:partner_id].blank?
          dispatches = dispatches.select {|d| d.partner_id == params[:partner_id].to_i}
        end
        if params[:material_id] != 'all' && !params[:material_id].blank?
          dispatches = dispatches.select {|d| d.material_ids.include? params[:material_id].to_i}
        end

        text_node "All dispatches"
        table_for dispatches do |dispatch|
          column :id
          column "Partner Email" do |dispatch|
            text_node dispatch.partner.email
          end
          column "Materials" do |dispatch|
            materials = ''
            dispatch.materials.each do |m|
              materials += m.title.to_s + ';'
            end
            text_node materials
          end
          column "Destination Emails" do |dispatch|
            emails = ''
            dispatch.dispatch_recipients.each do |dr|
              status = dr.status == 'confirmed' ? "\u2713" : "\u2717"
              emails = emails + dr.email + " (#{status.encode('utf-8')})" + ' '
            end
            text_node emails
          end
          column :created_at
        end
      end
      column :max_width => "250px" do
        panel "Filter" do
          render partial: "admin/dispatch_statistics_filter"
        end
      end
    end
  end
end
