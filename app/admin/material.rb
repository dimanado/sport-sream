ActiveAdmin.register Material do
  config.per_page = 40
  config.batch_actions = false

  scope :all, :default => true
  scope :files
  scope :images

  menu :label => "Marketing Library"

  filter :title

  action_item :only => :index do
    @dispatch = Dispatch.new
    form_for @dispatch do |f|
      div :class => 'button_send_field' do
        button_tag(type: 'submit', :id => "send_mail") do
          content_tag(:strong, 'Send mail')
        end
      end
      div :class => 'field_send_field' do
        text_field_tag :material_email, '', {:placeholder => "Email"}
      end
      div :class => 'field_send_field' do
        text_field_tag :material_subject, '', {:placeholder => "Subject"}
      end
      div :style => "clear: both"
      div :class => 'body_of_email' do
        text_area_tag :material_body
      end
    end
  end

  index :as => :grid, :title => 'Marketing Library', :download_links => false do |material|
    render partial: 'admin/share_scripts'
    div :for => material do
      div do
        if current_partner.role == "admin"
          link_to admin_material_path(material) do
            if material.file? && material.type_of_file == 'image'
              cl_image_tag(material.file.path, { size: '250x200', crop: :pad })
            else
              image_tag('text-file-icon.png', size: "200")
            end
          end
        else
          label_tag "material#{material.id}", :style => "cursor: pointer" do
            if material.file? && material.type_of_file == 'image'
              cl_image_tag(material.file.path, { size: '250x200', crop: :pad })
            else
              image_tag('text-file-icon.png', size: "200")
            end
          end
        end
      end
      span do
        check_box_tag "material#{material.id}", material.id
      end
      div :class => 'download_link' do
        if material.type_of_file == 'image'
          link_to 'download', download_material_path(material.id)
        else
          link_to 'download', material.full_path
        end
      end
      div :class => "title_material" do
        if current_partner.role == "admin"
          auto_link(material)
        else
          material.title
        end
      end
      if current_partner.role == "admin"
        div :class => "used_count" do
          link_to "Dispatched: " + material.dispatches.count.to_s, admin_dispatch_statistics_path(partner: 'all', material_id: material.id)
        end
        div :class => "download_count" do
          link_to "Downloaded: " + material.material_downloads.count.to_s, admin_material_download_statistics_path(partner_id: 'all', material_id: material.id)
        end
      end
    end
    render partial: 'admin/share_material', locals: {id: material.id, title: material.title, partner: current_partner.name}
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Detail" do
      f.input :title
      f.input :type_of_file, :as => :select, :collection => ['file','image']
      f.input :public
    end
    f.inputs "File" do
      f.attachinary_file_field :file
    end
    f.actions
  end
end
