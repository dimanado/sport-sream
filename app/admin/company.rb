ActiveAdmin.register Company do
	menu parent: "businesses"

	show do
	  attributes_table do
	    row :id
	    row :title
	    row :description
	    row :categories
	  end
	end 

  form do |f|
    f.inputs "Company" do
      f.input :title
      f.input :description
    end 
    f.actions
  end
  
end
