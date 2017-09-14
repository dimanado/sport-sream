<%- if params[:skip_mobile] == "true" %>
$("#<%= dom_id(@business) %>")
  .replaceWith("<%= j render('business.mobile.haml', :business => @business) %>")

$("#<%= dom_id(@business) %>")
  .parent()
    .listview("refresh")
<%- else %>
  $("#<%= dom_id(@business) %> .toggle-subscription").replaceWith("<%= j render 'subscription_links', :business => @business %>")
<%- end %>
