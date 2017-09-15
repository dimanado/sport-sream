ActiveAdmin.register Stream do
	menu parent: "businesses"

	show do
		attributes_table do
			row :id
			row :title
			row :link
		end
	end 

	form do |f|
		f.inputs "Stream" do
			f.input :title
			f.input :link
      f.input :location_id, :as => :select, :collection => Location.all.map {|u| [u.name, u.id]}, :include_blank => false
		end 
		f.actions
	end

end
