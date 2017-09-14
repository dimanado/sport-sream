class CategorizesCampaigns

  def self.categorize (campaigns)
    categories = {}

    campaigns.each do |c|
      top_level_categories = []

      c.business.categories.each do |category|
        cat = category.top_level? ? category : category.parent
        top_level_categories << cat unless top_level_categories.include?(cat)
      end

      top_level_categories.each do |cat|
        categories[cat.id] ||= [cat.name, 0]
        categories[cat.id][1] += 1
      end
    end

    categories
  end

  def self.filter_by_subcategories_ids (campaigns, ids)
    ids = ids.map(&:to_i)
    ids.each do |id|
      campaigns.select! {|c| c.business.has_category_id?(id)}
    end
    campaigns
  end

  def self.filter_by_category (campaigns, category)
    campaigns.select do |c|
      if category.top_level? and category.has_subcategories?
        !(c.business.categories & category.children).empty? or c.business.categories.include?(category)
      else
        c.business.categories.include?(category)
      end
    end
  end

end
