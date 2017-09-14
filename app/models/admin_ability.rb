# app/models/admin_ability.rb

# All back end users (i.e. Active Admin users) are authorized using this class
class AdminAbility
  include CanCan::Ability

  def initialize(partner)
    partner ||= Partner.new


    # can :read, Merchant, :partner_id => partner.id
    can :read, Transaction, :shopping_cart => { :partner_id => partner.id }
    can :read, ActiveAdmin::Page
    can :read, Business, :merchant => { :partner_id => partner.id }
    can :read, Partner, :id => partner.id
    can :update, Partner, :id => partner.id
    can :read, Campaign, :business => { :merchant => {:partner_id => partner.id}}
    can :read, ShoppingCartItem, :item => { :campaign => { :business => { :merchant => {:partner_id => partner.id}}}}
    can :read, Material, :public => true
    can :read, Notification, recipient_id: partner.id
    cannot :read, ActiveAdmin::Page, :name => "Material Download Statistics"
    cannot :read, ActiveAdmin::Page, :name => "Dispatch Statistics"

    if partner.role?('admin')
      can :read, :all
      can :manage, :all
    end

  end
end
