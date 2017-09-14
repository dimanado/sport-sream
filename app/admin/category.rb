ActiveAdmin.register Category do
  menu parent: "businesses"

    show do
      attributes_table do
        row :id
        row :name
        row :tag
        row "Subcategories" do
          category.subcategories.each do |subcategory|
            text_node subcategory.name
          end
        end
        row :created_at
        row :updated_at
      end
    end 

  form do |f|
    f.inputs "Category" do
      f.input :parent
      f.input :name
      f.input :tag
    end 
    f.inputs "Subcategories" do  #
      f.has_many :subcategories do |j|  
        j.inputs :name, :tag
      end  
    end  
    f.actions
  end
end
