module ApplicationHelper
  class BraintreeFormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::TagHelper

    def initialize(object_name, object, template, options, proc)
      super
      @braintree_params = @options[:params]
      @braintree_errors = @options[:errors]
      @braintree_existing = @options[:existing]
    end

    def fields_for(record_name, *args, &block)
      options = args.extract_options!
      options[:builder] = BraintreeFormBuilder
      options[:params] = @braintree_params && @braintree_params[record_name]
      options[:errors] = @braintree_errors && @braintree_errors.for(record_name)
      new_args = args + [options]
      super record_name, *new_args, &block
    end

    def text_field(method, options = {})
      has_errors = @braintree_errors && @braintree_errors.on(method).any?
      field = super(method, options.merge(:value => determine_value(method)))
      result = content_tag("div", field, :class => has_errors ? "fieldWithErrors" : "")
      result.safe_concat validation_errors(method)
      result
    end

    protected

    def determine_value(method)
      if @braintree_params
        @braintree_params[method]
      elsif @braintree_existing

        if @braintree_existing.kind_of?(Braintree::CreditCard)
          case method
          when :number
            return "******#{@braintree_existing.last_4}"
          when :cvv
            return nil
          end
        end

        @braintree_existing.send(method)
      else
        nil
      end
    end

    def validation_errors(method)
      if @braintree_errors && @braintree_errors.on(method).any?
        @braintree_errors.on(method).map do |error|
          content_tag("div", ERB::Util.h(error.message), {:style => "color: red;"})
        end.join
      else
        ""
      end
    end
  end

  def link_to_with_state(text, path, opts = {})
    state = path == request.path ? "active" : "inactive"

    classes = opts[:class].try(:split, " ") || []
    classes << state
    opts[:class] = classes.join(" ")
    link_to(text, path, opts)
  end

  def void_link (text, options)
    link_to text, 'javascript:void(0)', options
  end

  def image_url(source)
    (URI.parse(root_url) + image_path(source)).to_s
  end

  def ios_app?
    app = session[:app] || request.env['HTTP_USER_AGENT']
    app == 'Chinoki/iOS'
  end

  def qr_code (url)
    ''#image_tag "https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=#{url}&choe=UTF-8"
  end

  def redeem_url (coupon_code)
    redeem_businesses_url(:code => coupon_code.code)
  end

  def consumer
    current_consumer || Consumer.new
  end

  def merchant
    current_merchant || Merchant.new
  end

  def campaign_date_progressbar (campaign)
    return l(campaign.deliver_at) #unless campaign.delivered?

    # total_days = (campaign.expires_at - campaign.deliver_at) / 1.day
    # remaining_days = (campaign.expires_at - Time.now.to_datetime) / 1.day
    # remaining_days = 0 unless remaining_days >= 0
    # percentage = (total_days - remaining_days) * 100 / 100

    # content_tag :div, :class => 'progress-wrap' do
    #   content_tag :div, :class => 'progress-value', :style => "width: #{percentage}%" do
    #     content_tag :div, :class => 'progress', :rel => 'tooltip', :title => "Campaign expires in #{remaining_days.to_i} days" do
    #       l campaign.deliver_at
    #     end
    #   end
    # end
  end

  def link_to_shopping_cart
    summ = shopping_cart.shopping_cart_items.map(&:quantity).sum
    link_to "Shopping Cart (<strong class=\"count_shopping\">#{summ}</strong>)".html_safe, shopping_cart_path
  end

  def current_user
    return merchant if merchant_signed_in?
    return consumer if consumer_signed_in?
    nil
  end

  def user_signed_in?
    merchant_signed_in? || consumer_signed_in?
  end

  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

end
