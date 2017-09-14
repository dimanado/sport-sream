ActiveAdmin.register_page "Material Download Statistics" do
  # Menu
  menu parent: "materials", priority: 90

  content do
    columns do
      column :min_width => "810px" do
        material_downloads = MaterialDownload.all()
        if params[:partner_id] != 'all' && !params[:partner_id].blank?
          material_downloads = material_downloads.select {|md| md.partner_id == params[:partner_id].to_i}
        end
        if params[:material_id] != 'all' && !params[:material_id].blank?
          material_downloads = material_downloads.select {|md| md.material_id == params[:material_id].to_i}
        end

        table_for material_downloads  do |md|
          column :id
          column "Material" do |md|
            link_to md.material.title, admin_material_path(md.material)
          end
          column "Partner" do |md|
            link_to md.partner.name, admin_partner_path(md.partner)
          end
          column "Download Date" do |md|
            text_node md.updated_at
          end
        end
      end
      column :max_width => "250px" do
        panel "Filter" do
          render partial: "admin/material_download_filter"
        end
      end
    end
  end
end
