class CategoriesController < ApplicationController

  def index

  end

  def business_list
    @businesses = Business.all
    render :layout => 'pages'
  end

  def show
    category = Category.find_by_tag(params[:tag])

    if params[:iframe].present?
      if params[:other].present?
        matching_offers = CategorizesCampaigns.filter_by_category(all_offers, category)
        generate_entries(matching_offers)
      else
        matching_offers = CategorizesCampaigns.filter_by_category(all_offers_partner, category)
        generate_entries(matching_offers)
      end
      render :layout => 'page_iframe', :action => 'show'
    else
      matching_offers = CategorizesCampaigns.filter_by_category(all_offers, category)
      generate_entries(matching_offers)
      render :layout => 'pages', :action => 'show'
    end
  end

  def show_all
    params[:tag] = 'all-offers'
    if params[:iframe].present?
      if params[:other].present?
        generate_entries(all_offers)
      elsif params[:id].present?
        generate_entries(all_offers_business(params[:id]))
      elsif params[:hashtag].present?
        generate_entries(all_offers_hashtag(params[:hashtag]))
      else
        generate_entries(all_offers_partner)
      end
      render :layout => 'page_iframe', :action => 'show'
    else
      generate_entries(all_offers)
      render :layout => 'pages', :action => 'show'
    end
  end

  def show_partner
    params[:tag] = 'all-offers'
    partner = Partner.find_by_slug(params[:slug]) || Partner.default_partner

    generate_entries(partner.all_offers)

    if params[:iframe].present?
      render :layout => 'page_iframe', :action => 'show'
    else
      render :layout => 'pages', :action => 'show'
    end
  end



end
