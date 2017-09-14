class GeneratesCategoriesForSelect

  def self.generate(categories)
    data = []
    initial_set = all_parents(categories).sort_by!(&:name)

    initial_set.each do |category|
      data << [category.name, category.id]
      if category.has_subcategories?
        subcategories = subcategories_in_collection(category, categories).sort_by(&:name)

        subcategories.each do |subcat|
          data << ["- " + subcat.name, subcat.id]
        end
      end
    end

    data
  end

  def self.subcategories_in_collection (category, categories)
    categories.select {|c| c.parent_id == category.id }
  end

  def self.all_parents(categories)
    result = []
    categories.each {|c| result << (c.top_level? ? c : c.parent) }
    result.uniq
  end

end
