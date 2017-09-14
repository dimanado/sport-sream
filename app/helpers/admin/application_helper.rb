module Admin::ApplicationHelper
  def search_field (style, text='Search')
    content_tag(:div, :style => style) do
      concat 'Search '
      concat content_tag(:input, '', :type => 'text', :id => 'search')
      concat javascript_include_tag 'admin/search'
    end
  end
  def sort_links (string)
  	if params[:sort] 
  		if params[:sort][string] 
  			if params[:sort]["asc"] 
  				sort = "desc"
  				container = "arrow_up active"
  			else
  				sort = "asc"
  				container = "arrow_down"
  			end
  		else
  			sort = "asc"
  			container = "arrow_both"
  		end
  	else
  		sort = "asc"
  	end
    content_tag(:a, '', :href => "?sort=#{string} #{sort}", :class => 'sort_link') do
        concat content_tag(:i, string.humanize,:class => "sort_links text") 
        concat content_tag(:i, ' ',:class => "sort_links #{container}")
    end
  end
end
