class MaterialsController < ApplicationController
  def share
    @partner = Partner.find_by_slug(params[:p])
    session[:partner] = params[:p] if params[:p]
    @material = Material.find(params[:id])
    render layout: 'layouts/sharing'
  end

  def download
    material = Material.find(params[:id])
    data = open(material.full_path).read
    filename = material.title
    extension = material.file.path.split('.')[1]
    filename = filename + '.' + extension unless extension.nil?

    # log to material_downloads table
    md = MaterialDownload.create!(:material_id => params[:id], :partner_id => current_partner.id)

    send_data data, disposition: 'attachment', filename: filename
  end
end
